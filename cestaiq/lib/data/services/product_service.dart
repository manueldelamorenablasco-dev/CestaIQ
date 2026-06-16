import '../mock/mock_data.dart';
import '../models/price.dart';
import '../models/product.dart';
import '../models/supermarket.dart';

class ProductService {
  // Simula latencia de red para que el shimmer loading sea visible
  static const _delay = Duration(milliseconds: 400);

  Future<List<Product>> getProducts() async {
    await Future.delayed(_delay);
    return MockData.products;
  }

  Future<List<Supermarket>> getSupermarkets() async {
    await Future.delayed(_delay);
    return MockData.supermarkets;
  }

  Future<List<Price>> getPricesForProduct(String productId) async {
    await Future.delayed(_delay);
    final prices = MockData.prices
        .where((p) => p.productId == productId)
        .toList()
      ..sort((a, b) => a.amount.compareTo(b.amount)); // más barato primero
    return prices;
  }

  // Devuelve Map<supermarketId, total> para una lista de productos con cantidades
  Future<Map<String, double>> calculateCartTotals(
    Map<String, int> productQuantities, // productId -> quantity
  ) async {
    await Future.delayed(_delay);

    final Map<String, double> totals = {};
    for (final supermarket in MockData.supermarkets) {
      totals[supermarket.id] = 0;
    }

    for (final entry in productQuantities.entries) {
      final productId = entry.key;
      final quantity = entry.value;
      final prices = MockData.prices.where((p) => p.productId == productId);
      for (final price in prices) {
        totals[price.supermarketId] =
            (totals[price.supermarketId] ?? 0) + price.amount * quantity;
      }
    }

    return totals;
  }
}
