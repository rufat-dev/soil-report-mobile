import 'package:soilreport/src/core/component/custom_bottom_sheet.dart';
import 'package:soilreport/src/utils/app_theme.dart';
import 'package:soilreport/src/constants/utility_constants.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/utils/extensions/uri_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class SosBottomSheet extends ConsumerWidget {
  const SosBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomBottomSheet(
      initialChildSize: 0.4,
      minChildSize: 0.35,
      maxChildSize: 0.65,
      backgroundColor: Theme.of(context).colorScheme.surface,
      slivers: [
        SliverToBoxAdapter(
          child: _buildSosContent(context, ref),
        ),
      ],
    );
  }

  Widget _buildSosContent(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 15, top: 5),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.2,
        children: [
          _buildSosOption(
            context: context,
            icon: 'assets/images/static/heart-pulse.png',
            label: l10n.sosMedical,
            onTap: () => _launchPhoneCall(context, UtilityConstant.medicalSosPhoneNumber),
          ),
          _buildSosOption(
            context: context,
            icon: 'assets/images/static/car.png',
            label: l10n.sosTransport,
            onTap: () => _handleLocationSos(context),
          ),
          _buildSosOption(
            context: context,
            icon: 'assets/images/static/plane.png',
            label: l10n.sosTravel,
            onTap: () => _handleLocationSos(context),
          ),
          _buildSosOption(
            context: context,
            icon: 'assets/images/static/home.png',
            label: l10n.sosProperty,
            onTap: () => _handleLocationSos(context),
          ),
          _buildSosOption(
            context: context,
            icon: 'assets/images/static/phone.png',
            label: l10n.sosCallCenter,
            onTap: () => _launchPhoneCall(context, UtilityConstant.sosPhoneNumber),
          ),
        ],
      ),
    );
  }

  Widget _buildSosOption({
    required BuildContext context,
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 35, height: 35, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchPhoneCall(BuildContext context, String phoneNumber) async {
    final l10n = AppLocalizations.of(context);
    final phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await phoneUri.launchCall();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.sosCallLaunchError(phoneNumber)),
            backgroundColor: AppTheme().red,
          ),
        );
      }
    }
  }

  Future<void> _handleLocationSos(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text(l10n.sosGettingLocation),
          ],
        ),
        backgroundColor: AppTheme().orange,
        duration: const Duration(seconds: 3),
      ),
    );

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled && context.mounted) {
        _showLocationErrorDialog(context);
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied && context.mounted) {
          _showLocationErrorDialog(context);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever && context.mounted) {
        _showLocationErrorDialog(context);
        return;
      }

      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      // Location obtained — TODO: integrate with SOS service
    } catch (_) {
      if (context.mounted) {
        _showLocationErrorDialog(context);
      }
    }
  }

  void _showLocationErrorDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sosLocationRequiredTitle),
        content: Text(l10n.sosLocationRequiredBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.sosLocationCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openAppSettings();
            },
            child: Text(l10n.sosLocationOpenSettings),
          ),
        ],
      ),
    );
  }
}

void showSosBottomSheet(BuildContext context) {
  showCustomModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context) => const SosBottomSheet(),
  );
}
