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

    return AlertDialog(
      title: const Text('Filter by Price Level'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: availablePriceLevels.map((level) {
            return CheckboxListTile(
              title: Text(level['label']!),
              value: selectedPriceLevels.contains(level['id']),
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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done'),
        ),
      ],
    );
  }
}