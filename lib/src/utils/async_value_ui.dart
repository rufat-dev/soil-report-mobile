import 'package:soilreport/src/common_widgets/alert_dialogs.dart';
import 'package:soilreport/src/localization/localization_extension.dart';
import 'package:soilreport/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertOnError(BuildContext context) {
    if (!isLoading && hasError) {
      showExceptionAlert(
        context: context,
        title: 'Error'.translate(context),
        exception: error,
      );
    }
  }

}
