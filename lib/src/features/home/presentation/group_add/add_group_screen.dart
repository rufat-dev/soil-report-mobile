import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:soilreport/src/common_widgets/primary_button.dart';
import 'package:soilreport/src/features/home/domain/dashboard_device_model.dart';
import 'package:soilreport/src/features/home/presentation/dashboard_screen/dashboard_screen_controller.dart';
import 'package:soilreport/src/features/home/presentation/group_add/add_group_screen_controller.dart';
import 'package:soilreport/src/localization/app_localizations.dart';
import 'package:soilreport/src/routing/app_router.dart';
import 'package:soilreport/src/utils/themed_dialogs.dart';

bool _isUngrouped(DashboardDeviceModel d) {
  final g = d.groupId?.trim();
  return g == null || g.isEmpty;
}

class AddGroupScreen extends ConsumerStatefulWidget {
  const AddGroupScreen({super.key});

  @override
  ConsumerState<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends ConsumerState<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final Set<String> _selectedDeviceIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addGroupScreenControllerProvider.notifier).loadDevices();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(addGroupScreenControllerProvider);
    final activeState = ref
        .read(addGroupScreenControllerProvider.notifier)
        .effectiveState;
    final l10n = AppLocalizations.of(context);
    final isSubmitting = activeState.checkState?.isLoading ?? false;
    final ungrouped =
        activeState.devices.where(_isUngrouped).toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addGroupTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.addGroupNameLabel),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? l10n.addGroupRequiredField
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: l10n.addGroupNotesLabel),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.addGroupUngroupedDevicesTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (activeState.devicesLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (ungrouped.isEmpty)
                Text(
                  l10n.addGroupNoUngroupedDevices,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              else
                ...ungrouped.map(
                  (d) => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      d.deviceName?.trim().isNotEmpty == true
                          ? d.deviceName!
                          : d.deviceId,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      d.deviceId,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    value: _selectedDeviceIds.contains(d.deviceId),
                    onChanged: isSubmitting
                        ? null
                        : (selected) {
                            setState(() {
                              if (selected == true) {
                                _selectedDeviceIds.add(d.deviceId);
                              } else {
                                _selectedDeviceIds.remove(d.deviceId);
                              }
                            });
                          },
                  ),
                ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: l10n.addGroupSubmitButton,
                isLoading: isSubmitting,
                onPressed: (isSubmitting || activeState.devicesLoading)
                    ? null
                    : () => _submit(l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final deviceIds = _selectedDeviceIds.isEmpty
        ? null
        : List<String>.from(_selectedDeviceIds);
    final payload = GroupCreatePayload(
      groupName: _nameController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      deviceIds: deviceIds,
    );
    final ok = await ref
        .read(addGroupScreenControllerProvider.notifier)
        .submit(payload);
    if (!mounted) {
      return;
    }
    if (ok) {
      await showSuccessDialog(
        context: context,
        title: l10n.addGroupSuccessTitle,
        content: l10n.addGroupSuccessSubtitle,
      );
      if (mounted) {
        if (context.canPop()) {
          context.pop(true);
        } else {
          await ref
              .read(dashboardScreenControllerProvider.notifier)
              .loadScreen(useCache: false);
          if (mounted) {
            context.goNamed(AppRoute.home.name);
          }
        }
      }
      return;
    }
    await showErrorDialog(
      context: context,
      title: l10n.addGroupErrorTitle,
      content: l10n.addGroupErrorSubtitle,
    );
  }
}
