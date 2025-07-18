import 'dart:math';
import 'package:campsite/domain/entities/camp_site.dart';
import 'package:campsite/presentation/providers/camp_site_provider.dart';
import 'package:campsite/presentation/providers/filter_providers.dart';
import 'package:campsite/presentation/views/widgets/camp_site_card.dart';
import 'package:campsite/presentation/views/widgets/filters_row.dart';
import 'package:campsite/presentation/views/widgets/view_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  bool _isSearching = false;
  bool _isFiltering = true;
  bool _isGridView = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        ref.read(searchTextProvider.notifier).state = '';
      }
    });
  }

  void _toggleFilters() {
    setState(() {
      _isFiltering = !_isFiltering;
    });
  }

  void _toggleView(bool isGrid) {
    setState(() {
      _isGridView = isGrid;
    });
  }

  bool _hasActiveFilters() {
    return ref.watch(closeToWaterProvider) ||
        ref.watch(campFireAllowedProvider) ||
        ref.watch(createdAfterDateProvider) != null ||
        ref.watch(locationProximityProvider) != null ||
        ref.watch(hostLanguagesProvider).isNotEmpty ||
        ref.watch(suitableForProvider).isNotEmpty ||
        ref.watch(priceLevelsProvider).isNotEmpty;
  }

  Widget _buildPriorityChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 80,
        height: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: selected
              ? LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: selected ? null : theme.colorScheme.surface,
          border: Border.all(
            color: selected ? theme.colorScheme.primary : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(selected ? 0.2 : 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: selected ? Colors.white : theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final campSitesAsync = ref.watch(campSitesProvider);
    final hasActiveFilters = _hasActiveFilters();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          onChanged: (query) {
            ref.read(searchTextProvider.notifier).state = query;
          },
          decoration: InputDecoration(
            hintText: 'Search campsites...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            border: InputBorder.none,
            filled: true,
            fillColor: theme.colorScheme.primary.withOpacity(0.2),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        )
            : const Text(
          'Discover Campsites',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: hasActiveFilters ? Colors.amber : Colors.white,
            ),
            tooltip: _isFiltering ? 'Hide filters' : 'Show filters',
            onPressed: _toggleFilters,
          ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            tooltip: _isSearching ? 'Close search' : 'Search',
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            AnimatedCrossFade(
              firstChild: Column(
                children: [
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildPriorityChip(
                              context: context,
                              label: 'Close to Water',
                              selected: ref.watch(closeToWaterProvider),
                              icon: Icons.water,
                              gradientColors: [Colors.blue.shade400, Colors.blue.shade700],
                              onTap: () => ref.read(closeToWaterProvider.notifier).state =
                              !ref.watch(closeToWaterProvider),
                            ),
                            _buildPriorityChip(
                              context: context,
                              label: 'Campfire',
                              selected: ref.watch(campFireAllowedProvider),
                              icon: Icons.local_fire_department,
                              gradientColors: [Colors.orange.shade400, Colors.red.shade700],
                              onTap: () => ref.read(campFireAllowedProvider.notifier).state =
                              !ref.watch(campFireAllowedProvider),
                            ),
                          ],
                        ),
                        ViewToggle(
                          isGridView: _isGridView,
                          onToggle: _toggleView,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FiltersRow(ref: ref),
                  ),
                ],
              ),
              secondChild: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ViewToggle(
                      isGridView: _isGridView,
                      onToggle: _toggleView,
                    ),
                  ],
                ),
              ),
              crossFadeState: _isFiltering ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 400),
              alignment: Alignment.topCenter,
            ),
            Expanded(
              child: campSitesAsync.when(
                data: (campSites) {
                  final filtered = _filterCampSites(ref, campSites);
                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'No campsites found',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ) ?? const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return _isGridView
                      ? GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final campSite = filtered[index];
                      return CampSiteCard(campSite: campSite, isGridView: true);
                    },
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final campSite = filtered[index];
                      return CampSiteCard(campSite: campSite, isGridView: false);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    'Oops! Something went wrong:\n$error',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ) ?? const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CampSite> _filterCampSites(WidgetRef ref, List<CampSite> campSites) {
    final searchText = ref.watch(searchTextProvider).toLowerCase();
    final closeToWater = ref.watch(closeToWaterProvider);
    final campFireAllowed = ref.watch(campFireAllowedProvider);
    final createdAfter = ref.watch(createdAfterDateProvider);
    final locationProximity = ref.watch(locationProximityProvider);
    final selectedLanguages = ref.watch(hostLanguagesProvider);
    final selectedSuitableFor = ref.watch(suitableForProvider);
    final selectedPriceLevels = ref.watch(priceLevelsProvider);

    final filtered = campSites.where((site) {
      final matchesSearch = site.label.toLowerCase().contains(searchText);
      final matchesWater = !closeToWater || site.isCloseToWater;
      final matchesFire = !campFireAllowed || site.isCampFireAllowed;
      final matchesDate = createdAfter == null || site.createdAt.isAfter(createdAfter);
      final matchesLocation = locationProximity == null ||
          _isWithinRadius(
            site.geoLocation.lat,
            site.geoLocation.long,
            locationProximity['lat'] ?? 0.0,
            locationProximity['long'] ?? 0.0,
            locationProximity['radius'] ?? 0.0,
          );
      final matchesLanguages = selectedLanguages.isEmpty ||
          selectedLanguages.every((lang) => (site.hostLanguages).contains(lang));
      final matchesSuitableFor = selectedSuitableFor.isEmpty ||
          selectedSuitableFor.every((item) => (site.suitableFor).contains(item));
      final matchesPriceLevel = selectedPriceLevels.isEmpty ||
          selectedPriceLevels.any((level) {
            if (level == 'budget') return site.pricePerNight <= 5000;
            if (level == 'midrange') return site.pricePerNight > 5000 && site.pricePerNight <= 10000;
            if (level == 'premium') return site.pricePerNight > 10000;
            return false;
          });

      return matchesSearch &&
          matchesWater &&
          matchesFire &&
          matchesDate &&
          matchesLocation &&
          matchesLanguages &&
          matchesSuitableFor &&
          matchesPriceLevel;
    }).toList();

    filtered.sort((a, b) => a.label.compareTo(b.label));
    return filtered;
  }

  bool _isWithinRadius(double lat1, double lon1, double lat2, double lon2, double radius) {
    const double kmPerDegree = 111.0;
    final latDiff = (lat1 - lat2) * kmPerDegree;
    final lonDiff = (lon1 - lon2) * kmPerDegree * cos(lat1 * pi / 180);
    final distance = sqrt(latDiff * latDiff + lonDiff * lonDiff);
    return distance <= radius;
  }
}