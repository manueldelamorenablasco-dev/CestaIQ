import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/price.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../widgets/product_image.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logScreenView('product_detail');
  }

  @override
  Widget build(BuildContext context) {
    final productId = widget.productId;
    final productAsync = ref.watch(productByIdProvider(productId));
    final pricesAsync = ref.watch(productPricesProvider(productId));
    final cartItems = ref.watch(cartProvider);

    return productAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              const Text(
                'No se pudo cargar el producto',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
      data: (product) {
        if (product == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔍', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  const Text(
                    'Producto no disponible',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Este producto ya no está en el catálogo.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            ),
          );
        }

        final isInCart = cartItems.any((item) => item.product.id == productId);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            actions: [
              if (isInCart)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Chip(
                    avatar: const Icon(Icons.check, size: 14, color: AppColors.primary),
                    label: const Text('En cesta'),
                    backgroundColor: AppColors.primaryLight,
                    labelStyle: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 220,
                        child: ProductImage(
                          imageUrl: product.imageUrl,
                          fallbackEmoji: product.imageEmoji,
                          fit: BoxFit.contain,
                          size: ProductImageSize.large,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                product.category,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.brand,
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Precio',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            pricesAsync.when(
                              loading: () => const Center(
                                child: CircularProgressIndicator(
                                    color: AppColors.primary),
                              ),
                              error: (e, _) => const Text(
                                'No se pudo cargar el precio.',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                              data: (prices) => _PriceList(prices: prices),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    top: BorderSide(color: AppColors.divider, width: 0.5),
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(cartProvider.notifier).addProduct(product);
                    ref.read(analyticsServiceProvider).logAddToCart(
                      productId: product.id,
                      productName: product.name,
                      category: product.category,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text('Añadido a tu cesta'),
                          ],
                        ),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart_outlined),
                  label: Text(isInCart ? 'Añadir otra unidad' : 'Añadir a mi cesta'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PriceList extends StatelessWidget {
  final List<Price> prices;

  const _PriceList({required this.prices});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(prices.length, (i) {
        final price = prices[i];
        final isCheapest = i == 0;
        final supermarket = MockData.supermarkets
            .firstWhere((s) => s.id == price.supermarketId);

        // Ahorro respecto al más caro
        final maxPrice = prices.last.amount;
        final saving = maxPrice - price.amount;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCheapest ? AppColors.primaryLight : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: isCheapest
                ? Border.all(color: AppColors.primary, width: 1.5)
                : Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              // Logo supermercado (inicial)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: supermarket.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    supermarket.name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Nombre
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supermarket.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            isCheapest ? FontWeight.w700 : FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (isCheapest && saving > 0)
                      Text(
                        'Ahorras ${saving.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),

              // Precio
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${price.amount.toStringAsFixed(2)} €',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isCheapest
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (isCheapest)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'MEJOR PRECIO',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
