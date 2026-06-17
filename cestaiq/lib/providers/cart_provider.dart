import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/cart_item.dart';
import '../data/models/price.dart';
import '../data/models/product.dart';
import 'products_provider.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addProduct(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index)
            state[i].copyWith(quantity: state[i].quantity + 1)
          else
            state[i],
      ];
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void removeProduct(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }
    state = [
      for (final item in state)
        if (item.product.id == productId) item.copyWith(quantity: quantity) else item,
    ];
  }

  void clear() => state = [];

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) => CartNotifier());

// Precios individuales por producto para la cesta actual (usado en el detalle del resultado)
final cartItemPricesProvider = FutureProvider<Map<String, Price>>((ref) async {
  final cartItems = ref.watch(cartProvider);
  if (cartItems.isEmpty) return {};
  final productIds = cartItems.map((item) => item.product.id).toList();
  return ref.watch(productServiceProvider).getPricesMap(productIds);
});

// Totales por supermercado para la cesta actual
final cartTotalsProvider = FutureProvider<Map<String, double>>((ref) async {
  final cartItems = ref.watch(cartProvider);
  if (cartItems.isEmpty) return {};

  final quantities = {
    for (final item in cartItems) item.product.id: item.quantity
  };

  return ref.watch(productServiceProvider).calculateCartTotals(quantities);
});
