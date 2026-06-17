import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchCtrl = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final filteredAsync = ref.watch(filteredProductsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final featuredProducts = ref.watch(featuredProductsProvider);
    final categories = ref.watch(categoriesProvider).valueOrNull ?? const ['Todos'];
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Saludo (desaparece al hacer scroll) ────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(user?.displayName),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Text(
                            '¿Dónde es más barata tu compra hoy?',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('🛒', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ),
            ),

            // ── Búsqueda + Categorías (sticky) ──────────────────────────────
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(
                searchCtrl: _searchCtrl,
                searchQuery: searchQuery,
                categories: categories,
                selectedCategory: selectedCategory,
                onSearch: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                  _searchDebounce?.cancel();
                  _searchDebounce = Timer(const Duration(milliseconds: 800), () {
                    ref.read(analyticsServiceProvider).logSearch(value);
                  });
                },
                onClear: () {
                  _searchCtrl.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                },
                onCategorySelected: (cat) {
                  ref.read(selectedCategoryProvider.notifier).state =
                      cat == 'Todos' ? null : cat;
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Destacados (solo cuando no hay búsqueda activa) ─────────────
            if (searchQuery.isEmpty && selectedCategory == null) ...[
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text(
                    'Lo más buscado',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: featuredProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final product = featuredProducts[i];
                      return ProductCard(
                        product: product,
                        isHorizontal: true,
                        onTap: () => _openDetail(context, product.id),
                        onAddToCart: () {
                          ref.read(cartProvider.notifier).addProduct(product);
                          ref.read(analyticsServiceProvider).logAddToCart(
                            productId: product.id,
                            productName: product.name,
                            category: product.category,
                          );
                          _showAddedSnackbar(context, product.name);
                        },
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text(
                    'Todos los productos',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],

            // ── Grid de productos ───────────────────────────────────────────
            filteredAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $e')),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            const Text('🔍', style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 12),
                            Text(
                              'No encontramos "$searchQuery"',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.70,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final product = products[i];
                        return ProductCard(
                          product: product,
                          onTap: () => _openDetail(context, product.id),
                          onAddToCart: () {
                            ref.read(cartProvider.notifier).addProduct(product);
                            ref.read(analyticsServiceProvider).logAddToCart(
                              productId: product.id,
                              productName: product.name,
                              category: product.category,
                            );
                            _showAddedSnackbar(context, product.name);
                          },
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(productId: productId),
      ),
    );
  }

  void _showAddedSnackbar(BuildContext context, String name) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text('$name añadido a la cesta')),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _greeting(String? name) {
    final hour = DateTime.now().hour;
    final saludo = hour < 13
        ? 'Buenos días'
        : hour < 20
            ? 'Buenas tardes'
            : 'Buenas noches';
    final firstName = name?.split(' ').first ?? '';
    return firstName.isNotEmpty ? '$saludo, $firstName 👋' : saludo;
  }
}

// ── Delegate para la búsqueda + categorías fijas (sticky) ─────────────────────

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchCtrl;
  final String searchQuery;
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;
  final ValueChanged<String> onCategorySelected;

  // 8 top + 56 TextField + 8 gap + 44 categories + 8 bottom
  static const double _height = 124;

  const _SearchBarDelegate({
    required this.searchCtrl,
    required this.searchQuery,
    required this.categories,
    required this.selectedCategory,
    required this.onSearch,
    required this.onClear,
    required this.onCategorySelected,
  });

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.background,
        // Sombra sutil cuando hay contenido desplazándose por debajo
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
            : const [],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: TextField(
              controller: searchCtrl,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: onClear,
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = categories[i];
                final isSelected = cat == 'Todos'
                    ? selectedCategory == null
                    : selectedCategory == cat;
                return FilterChip(
                  label: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => onCategorySelected(cat),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate old) =>
      old.searchQuery != searchQuery ||
      old.selectedCategory != selectedCategory ||
      old.categories != categories;
}
