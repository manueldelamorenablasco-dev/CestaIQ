import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;
  bool _isRegister = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
    } catch (e) {
      setState(() => _error = 'No se pudo iniciar sesión con Google.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithEmail() async {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      setState(() => _error = 'Completa todos los campos.');
      return;
    }
    setState(() { _isLoading = true; _error = null; });
    try {
      final service = ref.read(authServiceProvider);
      if (_isRegister) {
        await service.registerWithEmail(_emailCtrl.text.trim(), _passCtrl.text);
      } else {
        await service.signInWithEmail(_emailCtrl.text.trim(), _passCtrl.text);
      }
    } on Exception catch (e) {
      setState(() => _error = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Logo + nombre
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text('🛒', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'CestaIQ',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              Text(
                _isRegister ? 'Crear cuenta' : 'Bienvenido de nuevo',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isRegister
                    ? 'Regístrate gratis y empieza a ahorrar.'
                    : 'Descubre dónde hacer tu compra más barata.',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 36),

              // Google Button
              _GoogleButton(
                onTap: _isLoading ? null : _signInWithGoogle,
              ),
              const SizedBox(height: 20),

              // Divider
              Row(children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'o continúa con email',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ]),
              const SizedBox(height: 20),

              // Email
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 12),

              // Password
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                onSubmitted: (_) => _signInWithEmail(),
              ),
              const SizedBox(height: 8),

              // Error
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.error, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                              color: AppColors.error, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              // Botón principal
              ElevatedButton(
                onPressed: _isLoading ? null : _signInWithEmail,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_isRegister ? 'Crear cuenta' : 'Iniciar sesión'),
              ),
              const SizedBox(height: 16),

              // Toggle login/register
              Center(
                child: TextButton(
                  onPressed: () =>
                      setState(() { _isRegister = !_isRegister; _error = null; }),
                  child: Text(
                    _isRegister
                        ? '¿Ya tienes cuenta? Inicia sesión'
                        : '¿No tienes cuenta? Regístrate gratis',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _GoogleButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider, width: 1.5),
          borderRadius: BorderRadius.circular(14),
          color: AppColors.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google logo simplificado con texto de color
            const Text(
              'G',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4285F4),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Continuar con Google',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
