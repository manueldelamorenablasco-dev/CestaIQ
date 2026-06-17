import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/cart_item.dart';
import '../data/models/price.dart';
import '../data/models/product.dart';
import 'products_provider.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  final Ref _ref;

  // Clave de SharedPreferences. Versionar permite migrar formato en el futuro.
  static const _kKey = 'cart_v1';

  CartNotifier(this._ref) : super([]) {
    _loadCart();
  }

  // ── Persistencia ──────────────────────────────────────────────────────────

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kKey);
      if (raw == null) return;

      final saved = (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();

      // Espera a que productsProvider resuelva antes de hidratar la cesta.
      // .future en FutureProvider es inmediato si ya hay caché, o espera si aún carga.
      final products = await _ref.read(productsProvider.future);
      final byId = {for (final p in products) p.id: p};

      final items = <CartItem>[];
      for (final e in saved) {
        final product = byId[e['id'] as String?];
        final qty = e['qty'] as int? ?? 1;
        // Si el producto ya no existe en el catálogo → se omite silenciosamente
        if (product != null && qty > 0) {
          items.add(CartItem(product: product, quantity: qty));
        }
      }

      if (items.isNotEmpty) state = items;
    } catch (_) {
      // Error de lectura o formato inesperado → cesta vacía, nunca crashear
    }
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = state
          .map((item) => {'id': item.product.id, 'qty': item.quantity})
          .toList();
      await prefs.setString(_kKey, jsonEncode(list));
    } catch (_) {}
  }

  // ── Operaciones ───────────────────────────────────────────────────────────

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
    _saveCart();
  }

  void removeProduct(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
    _saveCart();
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
    _saveCart();
  }

  void clear() {
    state = [];
    _saveCart();
  }

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(ref),
);

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
