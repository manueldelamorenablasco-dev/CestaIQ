import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/price.dart';
import '../data/models/product.dart';
import '../data/services/product_service.dart';

final productServiceProvider = Provider<ProductService>((ref) => ProductService());

// true si el caché local es válido (evita spinner en arranques con datos recientes)
final productsCacheValidProvider = FutureProvider<bool>((ref) {
  return ref.watch(productServiceProvider).isCacheValid();
});

// Todos los productos
final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productServiceProvider).getProducts();
});

// Texto de búsqueda
final searchQueryProvider = StateProvider<String>((ref) => '');

// Categoría seleccionada (null = Todos)
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Productos filtrados según búsqueda y categoría
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final category = ref.watch(selectedCategoryProvider);

  return productsAsync.whenData((products) {
    return products.where((p) {
      final matchesQuery = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.brand.toLowerCase().contains(query);
      final matchesCategory =
          category == null || category == 'Todos' || p.category == category;
      return matchesQuery && matchesCategory;
    }).toList();
  });
});

// Precios de un producto concreto (ordenados por precio)
final productPricesProvider =
    FutureProvider.family<List<Price>, String>((ref, productId) {
  return ref.watch(productServiceProvider).getPricesForProduct(productId);
});

// Producto por ID — busca en la lista ya cargada, sin lectura adicional a Firestore
final productByIdProvider = Provider.family<AsyncValue<Product?>, String>((ref, productId) {
  return ref.watch(productsProvider).whenData((products) {
    for (final p in products) {
      if (p.id == productId) return p;
    }
    return null;
  });
});

// Categorías reales desde Firestore/metadata (1 lectura)
final categoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(productServiceProvider).getCategories();
});

// Productos destacados — primeros productos reales cargados
final featuredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider).valueOrNull ?? [];
  return products.isEmpty ? [] : products.take(8).toList();
});
