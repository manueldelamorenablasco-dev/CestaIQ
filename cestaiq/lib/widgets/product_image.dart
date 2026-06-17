import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

enum ProductImageSize { small, medium, large }

/// Widget reutilizable para mostrar imágenes de producto con:
/// - Skeleton animado mientras carga
/// - Fallback emoji si la URL está vacía o falla
/// - Optimización automática de tamaño para imgix (Mercadona CDN)
class ProductImage extends StatelessWidget {
  final String imageUrl;
  final String fallbackEmoji;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final ProductImageSize size;

  const ProductImage({
    super.key,
    required this.imageUrl,
    required this.fallbackEmoji,
    this.fit = BoxFit.contain,
    this.borderRadius = BorderRadius.zero,
    this.size = ProductImageSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: ColoredBox(
        color: AppColors.surfaceVariant,
        child: imageUrl.isEmpty
            ? _EmojiFallback(emoji: fallbackEmoji)
            : CachedNetworkImage(
                imageUrl: _optimizedUrl(imageUrl, size),
                // imageBuilder convierte la imagen en DecorationImage (decoración pura,
                // no contenido), por lo que nunca afecta al layout ni provoca saltos.
                imageBuilder: (_, imageProvider) => SizedBox.expand(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholder: (_, __) => const _Skeleton(),
                errorWidget: (_, __, ___) => _EmojiFallback(emoji: fallbackEmoji),
              ),
      ),
    );
  }

  /// Transforma URLs de imgix (Mercadona) para pedir el tamaño justo.
  /// Deja intactas las URLs de otros dominios.
  static String _optimizedUrl(String url, ProductImageSize size) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.host.contains('imgix.net')) return url;
    final px = switch (size) {
      ProductImageSize.small => '80',
      ProductImageSize.medium => '120',
      ProductImageSize.large => '600',
    };
    final params = Map<String, String>.from(uri.queryParameters)
      ..['w'] = px
      ..['h'] = px
      ..['fit'] = 'crop';
    return uri.replace(queryParameters: params).toString();
  }
}

// ── Skeleton pulsante ─────────────────────────────────────────────────────────

class _Skeleton extends StatefulWidget {
  const _Skeleton();
  @override
  State<_Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<_Skeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => ColoredBox(
          color: Color.lerp(
            AppColors.surfaceVariant,
            AppColors.divider,
            _anim.value,
          )!,
          child: const SizedBox.expand(),
        ),
      );
}

// ── Emoji fallback ────────────────────────────────────────────────────────────

class _EmojiFallback extends StatelessWidget {
  final String emoji;
  const _EmojiFallback({required this.emoji});

  @override
  Widget build(BuildContext context) => Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(emoji, style: const TextStyle(fontSize: 48)),
          ),
        ),
      );
}
