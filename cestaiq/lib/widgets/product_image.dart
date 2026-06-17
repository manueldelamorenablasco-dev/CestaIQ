import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

enum ProductImageSize { small, medium, large }

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final String fallbackEmoji;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final ProductImageSize size;
  final double scale;

  const ProductImage({
    super.key,
    required this.imageUrl,
    required this.fallbackEmoji,
    this.fit = BoxFit.contain,
    this.borderRadius = BorderRadius.zero,
    this.size = ProductImageSize.medium,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: ColoredBox(
        color: Colors.white,
        child: imageUrl.isEmpty
            ? _EmojiFallback(emoji: fallbackEmoji)
            : CachedNetworkImage(
                imageUrl: _optimizedUrl(imageUrl, size),
                imageBuilder: (_, imageProvider) {
                  final image = SizedBox.expand(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: fit,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  );
                  return scale != 1.0
                      ? Transform.scale(scale: scale, child: image)
                      : image;
                },
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholder: (_, __) => const _Skeleton(),
                errorWidget: (_, __, ___) => _EmojiFallback(emoji: fallbackEmoji),
              ),
      ),
    );
  }

  static String _optimizedUrl(String url, ProductImageSize size) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.host.contains('imgix.net')) return url;
    final px = switch (size) {
      ProductImageSize.small => '80',
      ProductImageSize.medium => '300',
      ProductImageSize.large => '600',
    };
    final params = Map<String, String>.from(uri.queryParameters)
      ..['w'] = px
      ..['h'] = px
      ..['fit'] = 'fill';
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
