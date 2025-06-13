import 'package:campsite/presentation/providers/filter_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationFilterDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const LocationFilterDialog({super.key, required this.ref});

  @override
  ConsumerState<LocationFilterDialog> createState() => _LocationFilterDialogState();
}

class _LocationFilterDialogState extends ConsumerState<LocationFilterDialog> {
  late TextEditingController _latController;
  late TextEditingController _longController;
  late TextEditingController _radiusController;

  @override
  void initState() {
    super.initState();
    final location = widget.ref.read(locationProximityProvider);
    _latController = TextEditingController(text: location?['lat']?.toString() ?? '');
    _longController = TextEditingController(text: location?['long']?.toString() ?? '');
    _radiusController = TextEditingController(text: location?['radius']?.toString() ?? '10');
  }

  @override
  void dispose() {
    _latController.dispose();
    _longController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter by Location'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _latController,
            decoration: const InputDecoration(
              labelText: 'Latitude',
              hintText: 'e.g., 40.7128',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          TextField(
            controller: _longController,
            decoration: const InputDecoration(
              labelText: 'Longitude',
              hintText: 'e.g., -74.0060',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          TextField(
            controller: _radiusController,
            decoration: const InputDecoration(
              labelText: 'Radius (km)',
              hintText: 'e.g., 10',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final lat = double.tryParse(_latController.text);
            final long = double.tryParse(_longController.text);
            final radius = double.tryParse(_radiusController.text);
            if (lat != null &&
                long != null &&
                radius != null &&
                radius > 0 &&
                lat >= -90 &&
                lat <= 90 &&
                long >= -180 &&
                long <= 180) {
              widget.ref.read(locationProximityProvider.notifier).state = {
                'lat': lat,
                'long': long,
                'radius': radius,
              };
              Navigator.pop(context);
            }
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}