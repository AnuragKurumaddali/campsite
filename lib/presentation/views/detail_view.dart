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
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.4; // 40% of screen height for top image

    return Scaffold(
      body: Column(
        children: [
          // Image at the top
          SizedBox(
            height: imageHeight,
            width: double.infinity,
            child: Hero(
              tag: campSite.id,
              child: Stack(
                children: [
                  Image.network(
                    campSite.photo,
                    width: double.infinity,
                    height: imageHeight,
                    fit: BoxFit.fill,
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
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Shrink-wrap the Row
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7, // Limit text width
                              ),
                              child: Text(
                                campSite.label,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Card at the bottom with scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '€${campSite.pricePerNight.toStringAsFixed(2)}/night',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
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
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final refContainer = ProviderScope.containerOf(context);

          refContainer.read(tabIndexProvider.notifier).state = 1; // Switch to Map
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
      color: Colors.white.withOpacity(0.7), // Semi-transparent inner cards
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