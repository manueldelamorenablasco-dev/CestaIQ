import '../mock/mock_data.dart';
import '../models/price.dart';
import '../models/product.dart';
import '../models/supermarket.dart';
import 'firestore_product_service.dart';

/// Servicio unificado de productos.
///
/// Intenta obtener datos de Firestore. Si falla o no hay datos,
/// cae automáticamente a los datos mock para que la app nunca quede vacía.
class ProductService {
  final FirestoreProductService _firestore = FirestoreProductService();

  // Latencia mínima para que el shimmer loading sea visible en mock
  static const _mockDelay = Duration(milliseconds: 400);

  Future<List<Product>> getProducts() async {
    try {
      final products = await _firestore.getProducts();
      if (products.isNotEmpty) return products;
    } catch (_) {}
    await Future.delayed(_mockDelay);
    return MockData.products;
  }

  Future<List<Supermarket>> getSupermarkets() async {
    try {
      final supermarkets = await _firestore.getSupermarkets();
      if (supermarkets.isNotEmpty) return supermarkets;
    } catch (_) {}
    await Future.delayed(_mockDelay);
    return MockData.supermarkets;
  }

  Future<List<Price>> getPricesForProduct(String productId) async {
    try {
      final price = await _firestore.getPriceForProduct(productId);
      if (price != null) return [price];
    } catch (_) {}
    await Future.delayed(_mockDelay);
    return MockData.prices
        .where((p) => p.productId == productId)
        .toList()
      ..sort((a, b) => a.amount.compareTo(b.amount));
  }

  Future<Map<String, double>> calculateCartTotals(
    Map<String, int> productQuantities,
  ) async {
    try {
      final totals = await _firestore.calculateCartTotals(productQuantities);
      if (totals.isNotEmpty) return totals;
    } catch (_) {}
    // fallback mock
    await Future.delayed(_mockDelay);
    final Map<String, double> totals = {
      for (final sm in MockData.supermarkets) sm.id: 0.0,
    };
    for (final entry in productQuantities.entries) {
      for (final price in MockData.prices.where((p) => p.productId == entry.key)) {
        totals[price.supermarketId] =
            (totals[price.supermarketId] ?? 0) + price.amount * entry.value;
      }
    }
    return totals;
  }

  Future<List<String>> getCategories() async {
    try {
      final cats = await _firestore.getCategories();
      if (cats.length > 1) return cats; // >1 porque siempre incluye "Todos"
    } catch (_) {}
    return MockData.categories;
  }
}
