import 'package:soilreport/src/exceptions/app_exception.dart';
import 'package:soilreport/src/localization/localization_extension.dart';
import 'package:soilreport/src/localization/string_hardcoded.dart';
import 'package:soilreport/src/utils/context_shortcuts.dart';
import 'package:soilreport/src/utils/themed_snackbars.dart';
import 'package:soilreport/src/utils/themed_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const kDialogDefaultKey = Key('dialog-default-key');

/// Generic function to show a platform-aware Material or Cupertino dialog
Future<bool?> showAlert({
  required BuildContext context,
  required String title,
  required AlertWidgetType type,
  String? content,
  String? cancelActionText,
  String defaultActionText = 'OK',
}) async {
  switch (type) {
    case AlertWidgetType.dialog:
      {
        return showDialog<bool>(
          context: context,
          // * Only make the dialog dismissible if there is a cancel button
          barrierDismissible: cancelActionText != null,
          builder: (dialogContext) => ErrorDialog(
            title: title,
            content: content?.translate(context) ?? '',
            confirmText: defaultActionText,
            onConfirm: () => Navigator.of(dialogContext).pop(true),
            cancelText: cancelActionText,
            onCancel: () => Navigator.of(dialogContext).pop(false),
          ),
        );
      }
    case AlertWidgetType.snack:
      {
        context.showSnackBar(ErrorSnackBar(message: content ?? ""));
        return Future.value(null);
      }
  }
}

/// Generic function to show a platform-aware Material or Cupertino error dialog
Future<void> showExceptionAlert({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) {
  if (exception is AppException) {
    return showAlert(
      context: context,
      title: title,
      content: exception.toString().translate(context),
      defaultActionText: 'OK'.hardcoded,
      type: exception.type,
    );
  } else {
    return showAlert(
      context: context,
      title: title,
      content: exception.toString(),
      defaultActionText: 'OK'.hardcoded,
      type: AlertWidgetType.dialog,
    );
  }
}

Future<void> showNotImplementedAlertDialog({required BuildContext context}) =>
    showAlert(
      context: context,
      title: 'Not implemented'.hardcoded,
      type: AlertWidgetType.dialog,
    );
