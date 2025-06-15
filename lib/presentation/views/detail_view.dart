import 'package:campsite/core/utils/location_utils.dart';
import 'package:campsite/presentation/providers/filter_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/camp_site.dart';

class DetailView extends StatelessWidget {
  final CampSite campSite;
  const DetailView({super.key, required this.campSite});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalizedLat = LocationUtils.normalizeLatitude(campSite.geoLocation.lat);
    final normalizedLong = LocationUtils.normalizeLongitude(campSite.geoLocation.long);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = isLandscape ? screenWidth * 0.4 : screenWidth * 0.6;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: imageHeight,
            floating: false,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.onSurface,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: screenWidth * 0.4),
                    child: Text(
                      campSite.label,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            leadingWidth: screenWidth * 0.6,
            clipBehavior: Clip.hardEdge,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: campSite.id,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          campSite.photo,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.surface.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Card(
                margin: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
                elevation: 3,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '€${campSite.pricePerNight.toStringAsFixed(2)}/night',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _InfoCard(
                        icon: Icons.water_drop,
                        title: 'Close to Water',
                        value: campSite.isCloseToWater ? 'Available' : 'Not Available',
                      ),
                      _InfoCard(
                        icon: Icons.local_fire_department,
                        title: 'Campfire Allowed',
                        value: campSite.isCampFireAllowed ? 'Available' : 'Not Available',
                      ),
                      _InfoCard(
                        icon: Icons.language,
                        title: 'Languages',
                        value: campSite.hostLanguages.join(', '),
                      ),
                      _InfoCard(
                        icon: Icons.location_on,
                        title: 'Location',
                        value: 'Lat ${normalizedLat.toStringAsFixed(2)}, Long ${normalizedLong.toStringAsFixed(2)}',
                      ),
                      _InfoCard(
                        icon: Icons.calendar_today,
                        title: 'Listed Since',
                        value: DateFormat('MMM d, yyyy').format(campSite.createdAt),
                      ),
                      _InfoCard(
                        icon: Icons.directions_run,
                        title: 'Suitable For',
                        value: campSite.suitableFor.join(', '),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final refContainer = ProviderScope.containerOf(context);
          refContainer.read(tabIndexProvider.notifier).state = 1;
          refContainer.read(focusedCoordinateProvider.notifier).state =
              LatLng(normalizedLat, normalizedLong);
          Navigator.pop(context);
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        label: const Text('Go to Map'),
        icon: const Icon(Icons.map),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}