import 'package:soilreport/src/common_widgets/empty_placeholder_widget.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:flutter/material.dart';

/// Simple not found screen used for 404 errors (page not found on web)
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: EmptyPlaceholderWidget(
        message: l10n.notFoundPageMessage,
      ),
    );
  }
}
