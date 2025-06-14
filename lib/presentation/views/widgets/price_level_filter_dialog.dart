import 'package:campsite/presentation/providers/filter_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PriceLevelFilterDialog extends ConsumerWidget {
  const PriceLevelFilterDialog({super.key, required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPriceLevels = ref.watch(priceLevelsProvider);
    final availablePriceLevels = [
      {'id': 'budget', 'label': 'Budget (€0–5000)'},
      {'id': 'midrange', 'label': 'Mid-range (€5000–10000)'},
      {'id': 'premium', 'label': 'Premium (€10000+)'},
    ];
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Filter by Price Level',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: availablePriceLevels.map((level) {
            return CheckboxListTile(
              title: Text(
                level['label']!,
                style: theme.textTheme.bodyLarge,
              ),
              value: selectedPriceLevels.contains(level['id']),
              activeColor: theme.colorScheme.primary,
              onChanged: (value) {
                final updated = List<String>.from(selectedPriceLevels);
                if (value == true && !updated.contains(level['id'])) {
                  updated.add(level['id']!);
                } else if (value == false) {
                  updated.remove(level['id']);
                }
                ref.read(priceLevelsProvider.notifier).state = updated;
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