import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/mock_data.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/cart_provider.dart';

class CartResultScreen extends ConsumerStatefulWidget {
  const CartResultScreen({super.key});

  @override
  ConsumerState<CartResultScreen> createState() => _CartResultScreenState();
}

class _CartResultScreenState extends ConsumerState<CartResultScreen> {
  bool _logged = false;

  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logScreenView('cart_result');
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final totalsAsync = ref.watch(cartTotalsProvider);
    final pricesMap = ref.watch(cartItemPricesProvider).valueOrNull ?? {};

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Resultado de tu cesta')),
      body: totalsAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16),
              Text('Comparando precios...',
                  style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (totals) {
          if (totals.isEmpty) {
            return const Center(child: Text('No hay datos disponibles.'));
          }

          // Ordenar por total (más barato primero)
          final sorted = totals.entries.toList()
            ..sort((a, b) => a.value.compareTo(b.value));

          final cheapestId = sorted.first.key;
          final mostExpensiveId = sorted.last.key;
          final saving = sorted.last.value - sorted.first.value;

          final cheapestSupermarket = MockData.supermarkets
              .firstWhere((s) => s.id == cheapestId);

          if (!_logged) {
            _logged = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(analyticsServiceProvider).logCartCompleted(
                cheapestSupermarket: cheapestSupermarket.name,
                cheapestPrice: sorted.first.value,
                saving: saving,
                itemCount: cartItems.length,
              );
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Banner de ahorro ────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00A86B), Color(0xFF007A4D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mejor opción',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cheapestSupermarket.name,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (saving > 0.01) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('💰', style: TextStyle(fontSize: 18)),
                              const SizedBox(width: 8),
                              Text(
                                'Ahorras ${saving.toStringAsFixed(2)} €',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else
                        const Text(
                          'Tu cesta tiene precio similar en todos los supermercados',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Coste total por supermercado',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${cartItems.length} productos · '
                  '${cartItems.fold(0, (s, i) => s + i.quantity)} unidades',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Tarjeta por supermercado ────────────────────────────
                ...sorted.asMap().entries.map((entry) {
                  final rank = entry.key;
                  final supermarketId = entry.value.key;
                  final total = entry.value.value;
                  final supermarket = MockData.supermarkets
                      .firstWhere((s) => s.id == supermarketId);
                  final isCheapest = supermarketId == cheapestId;
                  final isMostExpensive = supermarketId == mostExpensiveId;
                  final diffVsCheapest = total - sorted.first.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isCheapest
                          ? AppColors.primaryLight
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: isCheapest
                          ? Border.all(
                              color: AppColors.primary, width: 1.5)
                          : Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        // Posición
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isCheapest
                                ? AppColors.primary
                                : AppColors.surfaceVariant,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${rank + 1}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isCheapest
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Logo
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
                        const SizedBox(width: 12),

                        // Nombre + diff
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                supermarket.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isCheapest
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (isCheapest)
                                const Text(
                                  'Mejor precio ✓',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              else if (diffVsCheapest > 0.01)
                                Text(
                                  '+${diffVsCheapest.toStringAsFixed(2)} € más caro',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Total
                        Text(
                          '${total.toStringAsFixed(2)} €',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: isCheapest
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // ── Detalle de la cesta ──────────────────────────────────
                const Text(
                  'Detalle de tu cesta',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final item = cartItems[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Text(item.product.imageEmoji,
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    [
                                      if (item.product.format.isNotEmpty) item.product.format,
                                      'x${item.quantity}',
                                    ].join(' · '),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Precio en cada supermercado
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: sorted.map((e) {
                                final smId = e.key;
                                final price = pricesMap[item.product.id];
                                final hasPrice = price != null && price.supermarketId == smId;
                                final isCheapestSm = smId == cheapestId;
                                return Container(
                                  width: 60,
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    hasPrice
                                        ? '${(price.amount * item.quantity).toStringAsFixed(2)} €'
                                        : '–',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isCheapestSm
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: isCheapestSm
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
