import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:soilreport/src/localization/app_localizations.dart';

class DeviceLocationPickerScreen extends StatefulWidget {
  const DeviceLocationPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  final double? initialLatitude;
  final double? initialLongitude;

  @override
  State<DeviceLocationPickerScreen> createState() =>
      _DeviceLocationPickerScreenState();
}

class _DeviceLocationPickerScreenState
    extends State<DeviceLocationPickerScreen> {
  late LatLng _selectedLatLng;
  bool _loadingCurrentLocation = false;

  @override
  void initState() {
    super.initState();
    _selectedLatLng = LatLng(
      widget.initialLatitude ?? 40.4093,
      widget.initialLongitude ?? 49.8671,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addDeviceMapTitle)),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _selectedLatLng,
              initialZoom: 11,
              onTap: (_, latLng) {
                setState(() {
                  _selectedLatLng = latLng;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.soilreport.mobile',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLatLng,
                    width: 46,
                    height: 46,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 96,
            child: FloatingActionButton(
              onPressed: _loadingCurrentLocation ? null : _useCurrentLocation,
              child: _loadingCurrentLocation
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(_selectedLatLng),
              child: Text(l10n.addDeviceMapConfirmButton),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _loadingCurrentLocation = true;
    });
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedLatLng = LatLng(pos.latitude, pos.longitude);
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingCurrentLocation = false;
        });
      }
    }
  }
}
