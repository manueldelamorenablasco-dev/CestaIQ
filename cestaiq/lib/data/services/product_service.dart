import '../models/price.dart';
import '../models/product.dart';
import '../models/supermarket.dart';
import 'firestore_product_service.dart';

class ProductService {
  final FirestoreProductService _firestore = FirestoreProductService();

  Future<List<Product>> getProducts() async {
    return _firestore.getProducts();
  }

  Future<List<Supermarket>> getSupermarkets() async {
    return _firestore.getSupermarkets();
  }

  Future<List<Price>> getPricesForProduct(String productId) async {
    final price = await _firestore.getPriceForProduct(productId);
    return price != null ? [price] : [];
  }

  Future<Map<String, double>> calculateCartTotals(
    Map<String, int> productQuantities,
  ) async {
    return _firestore.calculateCartTotals(productQuantities);
  }

  Future<Map<String, Price>> getPricesMap(List<String> productIds) async {
    return _firestore.getPricesForProducts(productIds);
  }

  Future<List<String>> getCategories() async {
    return _firestore.getCategories();
  }

  Future<bool> isCacheValid() => _firestore.isCacheValid();
}
