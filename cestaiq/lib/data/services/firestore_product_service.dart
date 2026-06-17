import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mock/mock_data.dart';
import '../models/price.dart';
import '../models/product.dart';
import '../models/supermarket.dart';

/// Cuántas horas se considera válido el caché local antes de refrescar del servidor.
/// Ajusta según la frecuencia con la que ejecutas el script de importación.
const _cacheTtlHours = 24;

const _kLastSyncKey = 'firestore_products_last_sync';

class FirestoreProductService {
  final FirebaseFirestore _db;

  FirestoreProductService({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  // ── Productos ─────────────────────────────────────────────────────────────

  /// Devuelve productos usando caché local si tiene menos de [_cacheTtlHours]h.
  ///
  /// Lecturas de servidor:
  ///   - Primera vez en el dispositivo:          7.100 lecturas
  ///   - Arranques posteriores (< 24h):          0 lecturas  (SQLite local)
  ///   - Una vez al día máximo:                  7.100 lecturas
  Future<List<Product>> getProducts({String? supermarketId}) async {
    Query<Map<String, dynamic>> query = _db.collection('products');
    if (supermarketId != null) {
      query = query.where('supermarketId', isEqualTo: supermarketId);
    }
    query = query.orderBy('name');

    // Intentar desde caché si está dentro del TTL
    if (await _isCacheValid()) {
      try {
        final snap = await query.get(const GetOptions(source: Source.cache));
        if (snap.docs.isNotEmpty) {
          return snap.docs.map((d) => Product.fromFirestore(d.data())).toList();
        }
      } catch (_) {
        // Caché vacío o inválido → caer al servidor
      }
    }

    // Fetch del servidor y actualizar marca de tiempo
    final snap = await query.get(const GetOptions(source: Source.server));
    await _markSynced();
    return snap.docs.map((d) => Product.fromFirestore(d.data())).toList();
  }

  // ── Precios ───────────────────────────────────────────────────────────────

  /// 1 lectura de documento para ver el precio de un producto en un supermercado.
  Future<Price?> getPriceForProduct(String productId) async {
    final doc = await _db.collection('prices').doc(productId).get();
    if (!doc.exists || doc.data() == null) return null;
    return Price.fromFirestore(productId, doc.data()!);
  }

  /// Batch read: ceil(n/30) lecturas para los precios de n productos.
  /// Usado al calcular el resultado de la cesta.
  Future<Map<String, Price>> getPricesForProducts(List<String> productIds) async {
    final Map<String, Price> result = {};
    for (int i = 0; i < productIds.length; i += 30) {
      final chunk = productIds.sublist(
          i, (i + 30).clamp(0, productIds.length));
      final snap = await _db
          .collection('prices')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (final doc in snap.docs) {
        if (doc.data().isNotEmpty) {
          result[doc.id] = Price.fromFirestore(doc.id, doc.data());
        }
      }
    }
    return result;
  }

  /// Calcula el total de una cesta por supermercado.
  Future<Map<String, double>> calculateCartTotals(
    Map<String, int> productQuantities,
  ) async {
    final prices = await getPricesForProducts(productQuantities.keys.toList());
    final Map<String, double> totals = {};
    for (final entry in productQuantities.entries) {
      final price = prices[entry.key];
      if (price == null) continue;
      totals[price.supermarketId] =
          (totals[price.supermarketId] ?? 0) + price.amount * entry.value;
    }
    return totals;
  }

  // ── Categorías ────────────────────────────────────────────────────────────

  /// Lee la lista de categorías desde metadata/cestaiq (1 lectura)
  /// en lugar de escanear toda la colección products (7.100 lecturas).
  ///
  /// El script de importación escribe este documento automáticamente.
  Future<List<String>> getCategories() async {
    // Primero intentar caché local (0 lecturas de servidor)
    try {
      final doc = await _db
          .collection('metadata')
          .doc('cestaiq')
          .get(const GetOptions(source: Source.cache));
      final cats = _parseCategoryList(doc.data());
      if (cats.isNotEmpty) return ['Todos', ...cats];
    } catch (_) {}

    // Fallback al servidor (1 lectura)
    try {
      final doc = await _db.collection('metadata').doc('cestaiq').get();
      final cats = _parseCategoryList(doc.data());
      if (cats.isNotEmpty) return ['Todos', ...cats];
    } catch (_) {}

    return ['Todos'];
  }

  List<String> _parseCategoryList(Map<String, dynamic>? data) {
    if (data == null) return [];
    final raw = data['categories'];
    if (raw is List) return List<String>.from(raw);
    return [];
  }

  // ── Supermercados ─────────────────────────────────────────────────────────

  Future<List<Supermarket>> getSupermarkets() async {
    try {
      final snap = await _db.collection('supermarkets').get();
      if (snap.docs.isNotEmpty) {
        return snap.docs.map((d) {
          final data = d.data();
          return Supermarket(
            id: d.id,
            name: data['name'] as String? ?? d.id,
            color: _parseColor(data['color'] as String? ?? '#888888'),
          );
        }).toList();
      }
    } catch (_) {}
    return MockData.supermarkets;
  }

  // ── Control de caché ──────────────────────────────────────────────────────

  Future<bool> isCacheValid() => _isCacheValid();

  Future<bool> _isCacheValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSync = prefs.getInt(_kLastSyncKey) ?? 0;
      final age = DateTime.now().millisecondsSinceEpoch - lastSync;
      return age < _cacheTtlHours * 3600 * 1000;
    } catch (_) {
      return false;
    }
  }

  Future<void> _markSynced() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kLastSyncKey, DateTime.now().millisecondsSinceEpoch);
    } catch (_) {}
  }

  /// Fuerza refresco del servidor en la próxima llamada a getProducts().
  /// Útil si el usuario hace pull-to-refresh manualmente.
  Future<void> invalidateCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kLastSyncKey);
    } catch (_) {}
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Color _parseColor(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }
}
