import 'package:campsite/presentation/providers/filter_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuitableFilterDialog extends ConsumerWidget {
  const SuitableFilterDialog({super.key, required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSuitableFor = ref.watch(suitableForProvider);
    final availableActivities = ['Hiking', 'Families', 'Pets', 'Cycling', 'Fishing'];
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Filter by Suitable For',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableActivities.map((activity) {
            return CheckboxListTile(
              title: Text(
                activity,
                style: theme.textTheme.bodyLarge,
              ),
              value: selectedSuitableFor.contains(activity),
              activeColor: theme.colorScheme.primary,
              onChanged: (value) {
                final updated = List<String>.from(selectedSuitableFor);
                if (value == true && !updated.contains(activity)) {
                  updated.add(activity);
                } else if (value == false) {
                  updated.remove(activity);
                }
                ref.read(suitableForProvider.notifier).state = updated;
              },
            );
          }).toList(),
        ),
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
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            'Done',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}