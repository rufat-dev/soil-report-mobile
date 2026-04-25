import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:soilreport/src/common_widgets/primary_button.dart';
import 'package:soilreport/src/features/home/domain/dashboard_device_model.dart';
import 'package:soilreport/src/features/home/presentation/device_add/add_device_screen_controller.dart';
import 'package:soilreport/src/features/home/presentation/device_add/device_location_picker_screen.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/utils/extensions/async_value_extension.dart';
import 'package:soilreport/src/utils/themed_dialogs.dart';

class AddDeviceScreen extends ConsumerStatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  ConsumerState<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends ConsumerState<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deviceIdController = TextEditingController();
  final _deviceNameController = TextEditingController();
  final _locationNotesController = TextEditingController();
  final _firmwareController = TextEditingController();
  String? _selectedGroupId;
  int? _selectedPlantType;
  int? _selectedSoilType;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addDeviceScreenControllerProvider.notifier).loadFormData();
    });
  }

  @override
  void dispose() {
    _deviceIdController.dispose();
    _deviceNameController.dispose();
    _locationNotesController.dispose();
    _firmwareController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(addDeviceScreenControllerProvider);
    final activeState = ref
        .read(addDeviceScreenControllerProvider.notifier)
        .effectiveState;
    final l10n = AppLocalizations.of(context);
    final isLoading = activeState.checkState.isNullOrLoading;
    final selectedGroupTemplate = ref
        .read(addDeviceScreenControllerProvider.notifier)
        .resolveGroupTemplateDevice(_selectedGroupId);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addDeviceTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _deviceIdController,
                decoration: InputDecoration(labelText: l10n.addDeviceIdLabel),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? l10n.addDeviceRequiredField
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _deviceNameController,
                decoration: InputDecoration(labelText: l10n.addDeviceNameLabel),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                value: _selectedGroupId,
                decoration: InputDecoration(
                  labelText: l10n.addDeviceGroupDropdownLabel,
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.addDeviceGroupNoneOption),
                  ),
                  ...activeState.groups.map(
                    (group) => DropdownMenuItem<String?>(
                      value: group.groupId,
                      child: Text(group.groupName ?? group.groupId),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGroupId = value;
                  });
                },
              ),
              if (_selectedGroupId == null) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  value: _selectedPlantType,
                  decoration: InputDecoration(
                    labelText: l10n.addDevicePlantDropdownLabel,
                  ),
                  items: activeState.plants.isEmpty
                      ? [
                          const DropdownMenuItem<int?>(
                            enabled: false,
                            value: null,
                            child: Text('No plant types available'),
                          ),
                        ]
                      : activeState.plants
                          .map(
                            (plant) => DropdownMenuItem<int?>(
                              value: plant.plantType,
                              child: Text(
                                '${plant.plantName ?? l10n.addDevicePlantFallbackName} (${plant.plantType})',
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedPlantType = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  value: _selectedSoilType,
                  decoration: InputDecoration(
                    labelText: l10n.addDeviceSoilDropdownLabel,
                  ),
                  items: activeState.soils.isEmpty
                      ? [
                          const DropdownMenuItem<int?>(
                            enabled: false,
                            value: null,
                            child: Text('No soil types available'),
                          ),
                        ]
                      : activeState.soils
                          .map(
                            (soil) => DropdownMenuItem<int?>(
                              value: soil.soilType,
                              child: Text(
                                '${soil.name ?? l10n.addDeviceSoilFallbackName} (${soil.soilType})',
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedSoilType = value),
                ),
              ] else if (selectedGroupTemplate != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.addDeviceGroupAutofillInfo,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.addDeviceLocationLabel),
                subtitle: Text(
                  _latitude == null || _longitude == null
                      ? l10n.addDeviceLocationNotSelected
                      : '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.map_outlined),
                  onPressed: () async {
                    final picked = await Navigator.of(context).push<LatLng>(
                      MaterialPageRoute(
                        builder: (_) => DeviceLocationPickerScreen(
                          initialLatitude: _latitude,
                          initialLongitude: _longitude,
                        ),
                      ),
                    );
                    if (picked != null && mounted) {
                      setState(() {
                        _latitude = picked.latitude;
                        _longitude = picked.longitude;
                      });
                    }
                  },
                ),
              ),
              TextFormField(
                controller: _locationNotesController,
                decoration: InputDecoration(
                  labelText: l10n.addDeviceLocationNameLabel,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _firmwareController,
                decoration: InputDecoration(
                  labelText: l10n.addDeviceFirmwareLabel,
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: l10n.addDeviceSubmitButton,
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () => _submit(l10n, selectedGroupTemplate),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(
    AppLocalizations l10n,
    DashboardDeviceModel? selectedGroupTemplate,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final lat = _latitude;
    final lng = _longitude;
    final location = (lat != null && lng != null) ? '$lat,$lng' : null;

    final payload = DeviceCreatePayload(
      deviceId: _deviceIdController.text.trim(),
      deviceName: _deviceNameController.text.trim().isEmpty
          ? null
          : _deviceNameController.text.trim(),
      groupId: _selectedGroupId,
      plantType: _selectedGroupId != null
          ? selectedGroupTemplate?.plantType
          : _selectedPlantType,
      soilType: _selectedGroupId != null
          ? selectedGroupTemplate?.soilType
          : _selectedSoilType,
      location: location,
      locationNotes: _locationNotesController.text.trim().isEmpty
          ? null
          : _locationNotesController.text.trim(),
      firmwareVersion: _firmwareController.text.trim().isEmpty
          ? null
          : _firmwareController.text.trim(),
    );

    final ok = await ref
        .read(addDeviceScreenControllerProvider.notifier)
        .submit(payload);
    if (!mounted) {
      return;
    }
    if (ok) {
      await showSuccessDialog(
        context: context,
        title: l10n.addDeviceSuccessTitle,
        content: l10n.addDeviceSuccessSubtitle,
      );
      if (mounted) {
        context.pop(true);
      }
      return;
    }
    await showErrorDialog(
      context: context,
      title: l10n.addDeviceErrorTitle,
      content: l10n.addDeviceErrorSubtitle,
    );
  }
}
