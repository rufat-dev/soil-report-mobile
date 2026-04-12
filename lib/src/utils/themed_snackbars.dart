import 'package:flutter/material.dart';
import 'package:soilreport/src/utils/app_theme.dart';

class ErrorSnackBar extends SnackBar {
  ErrorSnackBar({super.key,
    required String message,
    Duration? duration,
    super.action,
  }) : super(
          content: Text(message),
          backgroundColor: AppTheme().error,
          duration: duration ?? const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
        );
}

class SuccessSnackBar extends SnackBar {
  SuccessSnackBar({super.key,
    required String message,
    Duration? duration,
    super.action,
  }) : super(
          content: Text(message),
          backgroundColor: AppTheme().success,
          duration: duration ?? const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
        );
}

class InfoSnackBar extends SnackBar {
  InfoSnackBar({super.key,
    required String message,
    Duration? duration,
    super.action,
  }) : super(
          content: Text(message),
          backgroundColor: AppTheme().info,
          duration: duration ?? const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
        );
}
