import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:flutter/material.dart';

/// Lucide PNG from `assets/images/static/` (monochrome/black artboard), tinted via [color].
class LucideThemedIcon extends StatelessWidget {
  const LucideThemedIcon({
    super.key,
    required this.fileName,
    this.size = 24,
    this.color,
  });

  /// File name only, e.g. `mail.png`.
  final String fileName;
  final double size;
  final Color? color;

  static const _basePath = 'assets/images/static/';

  /// Menu drawer: primary header in light mode, dark surface in dark mode.
  static Color menuDrawerIconTint(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return context.isDarkMode ? cs.onSurface.withAlpha(242) : cs.onPrimary;
  }

  /// Footer social row — slightly softer than [menuDrawerIconTint].
  static Color menuSocialIconTint(BuildContext context) {
    final base = menuDrawerIconTint(context);
    return base.withAlpha((255 * 0.45).round());
  }

  /// Trailing icons on text fields (primary border / surface).
  static Color inputFieldTrailingTint(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return context.isDarkMode
        ? cs.primary.withAlpha(230)
        : cs.primary.withAlpha(200);
  }

  @override
  Widget build(BuildContext context) {
    final effective = color ?? menuDrawerIconTint(context);
    return Image.asset(
      '$_basePath$fileName',
      width: size,
      height: size,
      color: effective,
    );
  }
}
