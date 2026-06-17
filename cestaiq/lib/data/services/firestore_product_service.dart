import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/price.dart';
import '../models/product.dart';
import '../models/supermarket.dart';

/// Implementación de ProductService que lee de Firestore.
/// Usa los datos importados por el script scripts/import_products/main.py.
class FirestoreProductService {
  final FirebaseFirestore _db;

  FirestoreProductService({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  /// Todos los productos, opcionalmente filtrados por supermarketId.
  Future<List<Product>> getProducts({String? supermarketId}) async {
    Query<Map<String, dynamic>> query = _db.collection('products');

    if (supermarketId != null) {
      query = query.where('supermarketId', isEqualTo: supermarketId);
    }

    final snap = await query.orderBy('category').get();
    return snap.docs
        .map((d) => Product.fromFirestore(d.data()))
        .toList();
  }

  /// Precio de un producto concreto (un único documento en la colección prices).
  Future<Price?> getPriceForProduct(String productId) async {
    final doc = await _db.collection('prices').doc(productId).get();
    if (!doc.exists || doc.data() == null) return null;
    return Price.fromFirestore(productId, doc.data()!);
  }

  /// Precios de múltiples productos a la vez (batch read).
  Future<Map<String, Price>> getPricesForProducts(List<String> productIds) async {
    final Map<String, Price> result = {};
    // Firestore whereIn acepta máx. 30 elementos
    for (int i = 0; i < productIds.length; i += 30) {
      final chunk = productIds.sublist(
          i, i + 30 > productIds.length ? productIds.length : i + 30);
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

  /// Calcula los totales de una cesta por supermercado.
  /// productQuantities: Map<productId, quantity>
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

  /// Categorías disponibles en Firestore (distintas).
  Future<List<String>> getCategories() async {
    final snap = await _db
        .collection('products')
        .orderBy('category')
        .get();
    final cats = snap.docs
        .map((d) => d.data()['category'] as String? ?? '')
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return ['Todos', ...cats];
  }

  /// Supermercados presentes en Firestore.
  Future<List<Supermarket>> getSupermarkets() async {
    final snap = await _db.collection('supermarkets').get();
    return snap.docs.map((d) {
      final data = d.data();
      return Supermarket(
        id: d.id,
        name: data['name'] as String? ?? d.id,
        color: _parseColor(data['color'] as String? ?? '#888888'),
      );
    }).toList();
  }

  Color _parseColor(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }
}
