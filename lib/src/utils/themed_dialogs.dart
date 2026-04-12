import 'package:flutter/material.dart';
import 'package:soilreport/src/utils/app_theme.dart';

/// Error dialog with red accent color
/// The dialog styling will inherit from DialogThemeData when shown via showDialog
class ErrorDialog extends AlertDialog {
  ErrorDialog({
    required String title,
    required String content,
    String? confirmText,
    VoidCallback? onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) : super(
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: AppTheme().red,
                size: 17,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title),
              ),
            ],
          ),
          content: Text(content),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 8.0),
          titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
          actionsPadding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
          actions: [
            if (cancelText != null)
              TextButton(
                onPressed: onCancel ?? () {},
                child: Text(cancelText, style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                ),),
              ),
            TextButton(
              onPressed: onConfirm ?? () {},
              style: TextButton.styleFrom(
                foregroundColor: AppTheme().red,
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                ),
              ),
              child: Text(confirmText ?? 'OK'),
            ),
          ],
        );
}

/// Success dialog with green accent color
/// The dialog styling will inherit from DialogThemeData when shown via showDialog
class SuccessDialog extends AlertDialog {
  SuccessDialog({
    required String title,
    required String content,
    String? confirmText,
    VoidCallback? onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) : super(
          title: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppTheme().lightGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title),
              ),
            ],
          ),
          content: Text(content),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 8.0),
          titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 12.0),
          actionsPadding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
          actions: [
            if (cancelText != null)
              TextButton(
                onPressed: onCancel ?? () {},
                child: Text(cancelText),
              ),
            TextButton(
              onPressed: onConfirm ?? () {},
              style: TextButton.styleFrom(
                foregroundColor: AppTheme().lightGreen,
              ),
              child: Text(confirmText ?? 'OK'),
            ),
          ],
        );
}

/// Info dialog with orange/primary accent color
/// The dialog styling will inherit from DialogThemeData when shown via showDialog
class InfoDialog extends AlertDialog {
  InfoDialog({
    required String title,
    required String content,
    String? confirmText,
    VoidCallback? onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) : super(
          title: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme().orange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title),
              ),
            ],
          ),
          content: Text(content),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 8.0),
          titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 12.0),
          actionsPadding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
          actions: [
            if (cancelText != null)
              TextButton(
                onPressed: onCancel ?? () {},
                child: Text(cancelText),
              ),
            TextButton(
              onPressed: onConfirm ?? () {},
              style: TextButton.styleFrom(
                foregroundColor: AppTheme().orange,
              ),
              child: Text(confirmText ?? 'OK'),
            ),
          ],
        );
}

/// Helper function to show error dialog
Future<T?> showErrorDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  String? confirmText,
  VoidCallback? onConfirm,
  String? cancelText,
  VoidCallback? onCancel,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) => ErrorDialog(
      title: title,
      content: content,
      confirmText: confirmText,
      onConfirm: () {
        Navigator.of(dialogContext).pop();
        onConfirm?.call();
      },
      cancelText: cancelText,
      onCancel: () {
        Navigator.of(dialogContext).pop();
        onCancel?.call();
      },
      barrierDismissible: barrierDismissible,
    ),
  );
}

/// Helper function to show success dialog
Future<T?> showSuccessDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  String? confirmText,
  VoidCallback? onConfirm,
  String? cancelText,
  VoidCallback? onCancel,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) => SuccessDialog(
      title: title,
      content: content,
      confirmText: confirmText,
      onConfirm: () {
        Navigator.of(dialogContext).pop();
        onConfirm?.call();
      },
      cancelText: cancelText,
      onCancel: () {
        Navigator.of(dialogContext).pop();
        onCancel?.call();
      },
      barrierDismissible: barrierDismissible,
    ),
  );
}

/// Helper function to show info dialog
Future<T?> showInfoDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  String? confirmText,
  VoidCallback? onConfirm,
  String? cancelText,
  VoidCallback? onCancel,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) => InfoDialog(
      title: title,
      content: content,
      confirmText: confirmText,
      onConfirm: () {
        Navigator.of(dialogContext).pop();
        onConfirm?.call();
      },
      cancelText: cancelText,
      onCancel: () {
        Navigator.of(dialogContext).pop();
        onCancel?.call();
      },
      barrierDismissible: barrierDismissible,
    ),
  );
}
