import 'package:soilreport/src/common_widgets/lucide_themed_icon.dart';
import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Lucide PNG from `assets/images/static/` for [TextInputWidget.trailing].
class TextInputLucideIcons {
  TextInputLucideIcons._();

  static Widget icon(
    BuildContext context,
    String fileName, {
    double size = 22,
  }) {
    return LucideThemedIcon(
      fileName: fileName,
      size: size,
      color: LucideThemedIcon.inputFieldTrailingTint(context),
    );
  }
}

class TextInputWidget extends StatelessWidget {
  final FocusNode focusNode;
  final TextInputType? keyboardType;
  final List<String>? autofillHints;
  final TextEditingController controller;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final bool obscureText;
  final bool autofocus;
  final bool? readOnly;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final Color? backgroundColor;

  /// Optional widget shown at the end of the field (e.g. Lucide icon via [TextInputLucideIcons.icon]).
  final Widget? trailing;

  const TextInputWidget({
    required this.focusNode,
    required this.controller,
    this.keyboardType,
    this.autofillHints,
    this.obscureText = false,
    this.autofocus = false,
    this.textAlign = TextAlign.center,
    this.inputFormatters,
    this.hintText,
    this.onSubmitted,
    this.onChanged,
    this.maxLength,
    this.contentPadding,
    this.readOnly,
    this.backgroundColor,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.primary.withAlpha(100),
          strokeAlign: BorderSide.strokeAlignInside,
          width: 4,
        ),
        borderRadius: BorderRadius.circular(10),
        color:
            backgroundColor ??
            (context.isDarkMode
                ? AppTheme().surfaceDark900
                : colorScheme.surface),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              keyboardType: keyboardType,
              autofillHints: autofillHints,
              focusNode: focusNode,
              controller: controller,
              autofocus: autofocus,
              obscureText: obscureText,
              maxLength: maxLength,
              textAlign: textAlign,
              readOnly: readOnly ?? false,
              textAlignVertical: TextAlignVertical.center,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                isCollapsed: true,
                counterText: '',
                maintainHintSize: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: hintText,
                contentPadding: contentPadding ?? EdgeInsets.zero,
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(fontSize: 14),
              ),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall!.copyWith(fontSize: 14),
              onSubmitted: onSubmitted,
              onChanged: onChanged,
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}
