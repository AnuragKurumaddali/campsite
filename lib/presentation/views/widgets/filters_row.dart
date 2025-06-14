import 'dart:async';
import 'package:campsite/presentation/providers/filter_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'location_filter_dialog.dart';
import 'languages_filter_dialog.dart';
import 'suitable_filter_dialog.dart';
import 'price_level_filter_dialog.dart';

class FiltersRow extends StatefulWidget {
  final WidgetRef ref;
  const FiltersRow({super.key, required this.ref});

  @override
  State<FiltersRow> createState() => _FiltersRowState();
}

class _FiltersRowState extends State<FiltersRow> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollHint = true;
  Timer? _scrollHintTimer;

  @override
  void initState() {
    super.initState();
    _scrollHintTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showScrollHint = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollHintTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: _buildChips(context),
          ),
        ),
        Positioned(
          right: 4,
          top: 0,
          bottom: 0,
          child: AnimatedOpacity(
            opacity: _showScrollHint ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800), // Smoother fade
            child: IgnorePointer(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChips(BuildContext context) {
    final ref = widget.ref;

    final createdAfter = ref.watch(createdAfterDateProvider);
    final locationProximity = ref.watch(locationProximityProvider);
    final selectedLanguages = ref.watch(hostLanguagesProvider);
    final selectedSuitableFor = ref.watch(suitableForProvider);
    final selectedPriceLevels = ref.watch(priceLevelsProvider);

    return [
      _buildCustomChip(
        context,
        label: createdAfter == null
            ? 'Any Date'
            : 'After ${DateFormat('yyyy-MM-dd').format(createdAfter)}',
        selected: createdAfter != null,
        icon: Icons.calendar_today_outlined,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );
          ref.read(createdAfterDateProvider.notifier).state = picked;
        },
        onDelete: createdAfter != null
            ? () => ref.read(createdAfterDateProvider.notifier).state = null
            : null,
      ),
      _buildCustomChip(
        context,
        label: locationProximity == null
            ? 'Any Location'
            : 'Within ${locationProximity['radius']!.toStringAsFixed(0)}km',
        selected: locationProximity != null,
        icon: Icons.location_on_outlined,
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => LocationFilterDialog(ref: ref),
          );
        },
        onDelete: locationProximity != null
            ? () => ref.read(locationProximityProvider.notifier).state = null
            : null,
      ),
      _buildCustomChip(
        context,
        label: selectedLanguages.isEmpty
            ? 'Any Language'
            : selectedLanguages.join(', '),
        selected: selectedLanguages.isNotEmpty,
        icon: Icons.language_outlined,
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => LanguagesFilterDialog(ref: ref),
          );
        },
        onDelete: selectedLanguages.isNotEmpty
            ? () => ref.read(hostLanguagesProvider.notifier).state = []
            : null,
      ),
      _buildCustomChip(
        context,
        label: selectedSuitableFor.isEmpty
            ? 'Any Activity'
            : selectedSuitableFor.join(', '),
        selected: selectedSuitableFor.isNotEmpty,
        icon: Icons.sports_outlined,
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => SuitableFilterDialog(ref: ref),
          );
        },
        onDelete: selectedSuitableFor.isNotEmpty
            ? () => ref.read(suitableForProvider.notifier).state = []
            : null,
      ),
      _buildCustomChip(
        context,
        label: selectedPriceLevels.isEmpty
            ? 'All Prices'
            : selectedPriceLevels
            .map((e) => e == 'budget' ? 'Budget' : e == 'midrange' ? 'Mid-range' : 'Premium')
            .join(', '),
        selected: selectedPriceLevels.isNotEmpty,
        icon: Icons.attach_money_outlined,
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => PriceLevelFilterDialog(ref: ref),
          );
        },
        onDelete: selectedPriceLevels.isNotEmpty
            ? () => ref.read(priceLevelsProvider.notifier).state = []
            : null,
      ),
    ].map((chip) => Padding(padding: const EdgeInsets.only(right: 12), child: chip)).toList();
  }

  Widget _buildCustomChip(
      BuildContext context, {
        required String label,
        required bool selected,
        required IconData icon,
        required VoidCallback onTap,
        VoidCallback? onDelete,
      }) {
    final theme = Theme.of(context);
    final textColor = selected
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSurface;

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
            colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: selected ? null : theme.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? theme.colorScheme.primary : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: textColor),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.clear, size: 20, color: textColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}