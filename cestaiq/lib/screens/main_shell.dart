import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../providers/analytics_provider.dart';
import '../providers/cart_provider.dart';
import 'cart/cart_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';

final _currentTabProvider = StateProvider<int>((ref) => 0);

const _tabScreenNames = ['home', 'cart', 'profile'];

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(_currentTabProvider);
    final cartItems = ref.watch(cartProvider);

    final screens = const [HomeScreen(), CartScreen(), ProfileScreen()];

    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentTab,
          onTap: (index) {
            ref.read(_currentTabProvider.notifier).state = index;
            ref.read(analyticsServiceProvider).logScreenView(_tabScreenNames[index]);
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Explorar',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartItems.isNotEmpty,
                label: Text(cartItems.length.toString()),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cartItems.isNotEmpty,
                label: Text(cartItems.length.toString()),
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Mi Cesta',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
