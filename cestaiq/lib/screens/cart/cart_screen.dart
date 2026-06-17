import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product_image.dart';
import 'cart_result_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Cesta'),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton.icon(
              onPressed: () => _confirmClear(context, ref),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Vaciar'),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? _EmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final item = cartItems[i];
                      return Dismissible(
                        key: Key(item.product.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.delete_outline,
                              color: AppColors.error),
                        ),
                        onDismissed: (_) {
                          ref
                              .read(cartProvider.notifier)
                              .removeProduct(item.product.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              // Miniatura producto
                              SizedBox(
                                width: 52,
                                height: 52,
                                child: ProductImage(
                                  imageUrl: item.product.imageUrl,
                                  fallbackEmoji: item.product.imageEmoji,
                                  borderRadius: BorderRadius.circular(10),
                                  size: ProductImageSize.small,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Nombre y categoría
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      [item.product.brand, item.product.format].where((s) => s.isNotEmpty).join(' · '),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Contador de cantidad
                              _QuantityControl(
                                quantity: item.quantity,
                                onDecrease: () {
                                  ref.read(cartProvider.notifier).updateQuantity(
                                        item.product.id,
                                        item.quantity - 1,
                                      );
                                },
                                onIncrease: () {
                                  ref.read(cartProvider.notifier).updateQuantity(
                                        item.product.id,
                                        item.quantity + 1,
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Botón comparar ──────────────────────────────────────
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      top: BorderSide(color: AppColors.divider, width: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${cartItems.length} producto${cartItems.length != 1 ? 's' : ''} en tu cesta',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${cartItems.fold(0, (s, i) => s + i.quantity)} unidades',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CartResultScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.compare_arrows),
                        label: const Text('¿Dónde es más barata?'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _confirmClear(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Vaciar cesta'),
        content: const Text('¿Seguro que quieres eliminar todos los productos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clear();
              Navigator.pop(context);
            },
            child: const Text('Vaciar',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _QuantityControl({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QBtn(icon: quantity == 1 ? Icons.delete_outline : Icons.remove,
            onTap: onDecrease,
            isDelete: quantity == 1),
        SizedBox(
          width: 32,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        _QBtn(icon: Icons.add, onTap: onIncrease),
      ],
    );
  }
}

class _QBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDelete;

  const _QBtn({required this.icon, required this.onTap, this.isDelete = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isDelete
              ? AppColors.error.withOpacity(0.08)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDelete ? AppColors.error : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🛒', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 20),
            const Text(
              'Tu cesta está vacía',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Busca productos y compáralos\nentre supermercados.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
