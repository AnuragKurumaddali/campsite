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

    return AlertDialog(
      title: const Text('Filter by Suitable For'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableActivities.map((activity) {
            return CheckboxListTile(
              title: Text(activity),
              value: selectedSuitableFor.contains(activity),
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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done'),
        ),
      ],
    );
  }
}