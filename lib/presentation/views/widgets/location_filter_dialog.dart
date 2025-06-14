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
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Filter by Location',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _latController,
            decoration: InputDecoration(
              labelText: 'Latitude',
              hintText: 'e.g., 40.7128',
              labelStyle: theme.textTheme.bodyLarge,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _longController,
            decoration: InputDecoration(
              labelText: 'Longitude',
              hintText: 'e.g., -74.0060',
              labelStyle: theme.textTheme.bodyLarge,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _radiusController,
            decoration: InputDecoration(
              labelText: 'Radius (km)',
              hintText: 'e.g., 10',
              labelStyle: theme.textTheme.bodyLarge,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: theme.colorScheme.primary),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            'Cancel',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        ElevatedButton(
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
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            'Apply',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}