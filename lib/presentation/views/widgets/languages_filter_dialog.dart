import 'package:campsite/presentation/providers/filter_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguagesFilterDialog extends ConsumerWidget {
  const LanguagesFilterDialog({super.key, required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguages = ref.watch(hostLanguagesProvider);
    final availableLanguages = ['en', 'pl', 'de', 'fr', 'es', 'it'];
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Filter by Host Languages',
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableLanguages.map((lang) {
            return CheckboxListTile(
              title: Text(
                lang.toUpperCase(),
                style: theme.textTheme.bodyLarge,
              ),
              value: selectedLanguages.contains(lang),
              onChanged: (value) {
                final updated = List<String>.from(selectedLanguages);
                if (value == true && !updated.contains(lang)) {
                  updated.add(lang);
                } else if (value == false) {
                  updated.remove(lang);
                }
                ref.read(hostLanguagesProvider.notifier).state = updated;
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Done'),
        ),
      ],
    );
  }
}