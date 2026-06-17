import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'providers/auth_provider.dart';
import 'providers/products_provider.dart';
import 'screens/main_shell.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: authAsync.when(
        loading: () => const _SplashScreen(),
        // MODO DEMO: sin Firebase configurado va directo a la app.
        // Cuando tengas Firebase real, cambia ambas líneas a LoginScreen.
        error: (_, __) => const _ProductsGate(),
        data: (user) => const _ProductsGate(),
      ),
    );
  }
}

// ── Gate de productos ─────────────────────────────────────────────────────────

class _ProductsGate extends ConsumerWidget {
  const _ProductsGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheAsync = ref.watch(productsCacheValidProvider);

    // Mientras se lee SharedPreferences (milisegundos), mostrar splash
    if (cacheAsync.isLoading) return const _SplashScreen();

    // Caché válido → los productos cargarán desde SQLite en milisegundos → ir directo a la app
    if (cacheAsync.valueOrNull == true) return const MainShell();

    // Caché vacío o expirado → hay que descargar del servidor
    final productsAsync = ref.watch(productsProvider);
    return productsAsync.when(
      loading: () => const _ProductsLoadingScreen(),
      error: (_, __) => _ProductsErrorScreen(
        onRetry: () {
          ref.invalidate(productsCacheValidProvider);
          ref.invalidate(productsProvider);
        },
      ),
      data: (_) => const MainShell(),
    );
  }
}

// ── Splash inicial (auth) ─────────────────────────────────────────────────────

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Logo(),
            const SizedBox(height: 20),
            const _AppTitle(),
            const SizedBox(height: 32),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pantalla de carga de productos (primera descarga desde servidor) ──────────

class _ProductsLoadingScreen extends StatelessWidget {
  const _ProductsLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Logo(),
              const SizedBox(height: 20),
              const _AppTitle(),
              const SizedBox(height: 48),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Cargando productos reales...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Estamos preparando más de 4.000 productos para ti. Esto solo tardará unos segundos la primera vez.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Pantalla de error de carga ────────────────────────────────────────────────

class _ProductsErrorScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const _ProductsErrorScreen({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Logo(),
              const SizedBox(height: 20),
              const _AppTitle(),
              const SizedBox(height: 40),
              const Text(
                'No hemos podido cargar los productos.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Comprueba tu conexión a internet e inténtalo de nuevo.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Reintentar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widgets reutilizables ─────────────────────────────────────────────────────

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/app_icon.png',
      width: 96,
      height: 96,
    );
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'CestaIQ',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
    );
  }
}
