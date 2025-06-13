import 'package:campsite/core/utils/location_utils.dart';
import 'package:campsite/domain/entities/camp_site.dart';
import 'package:campsite/presentation/views/detail_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'feature_icon.dart';

class CampSiteCard extends StatelessWidget {
  final CampSite campSite;
  final bool isGridView;

  const CampSiteCard({super.key, required this.campSite, required this.isGridView});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalizedLat = LocationUtils.normalizeLatitude(campSite.geoLocation.lat);
    final normalizedLong = LocationUtils.normalizeLongitude(campSite.geoLocation.long);
    return Card(
      margin: isGridView ? EdgeInsets.zero : const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      elevation: isGridView ? 6 : 3,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailView(campSite: campSite)),
        ),
        child: isGridView
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Hero(
                tag: campSite.id,
                child: Image.network(
                  campSite.photo,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.surface,
                      theme.colorScheme.surfaceContainerHighest,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campSite.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        FeatureIcon(
                          icon: Icons.water,
                          isActive: campSite.isCloseToWater,
                          activeColor: Colors.blueAccent,
                        ),
                        const SizedBox(width: 6),
                        FeatureIcon(
                          icon: Icons.local_fire_department,
                          isActive: campSite.isCampFireAllowed,
                          activeColor: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Listed: ${DateFormat('MMM d, yyyy').format(campSite.createdAt)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Lat: ${normalizedLat.toStringAsFixed(2)}, Long: ${normalizedLong.toStringAsFixed(2)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '€${campSite.pricePerNight.toStringAsFixed(2)} / night',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
            : SizedBox(
          height: 140,
          child: Row(
            children: [
              Hero(
                tag: campSite.id,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    campSite.photo,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campSite.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.water,
                            size: 16,
                            color: campSite.isCloseToWater ? Colors.blueAccent : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text('Near Water', style: theme.textTheme.bodySmall),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.local_fire_department,
                            size: 16,
                            color: campSite.isCampFireAllowed ? Colors.orange : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text('Campfire', style: theme.textTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Listed: ${DateFormat('MMM d, yyyy').format(campSite.createdAt)}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Lat: ${normalizedLat.toStringAsFixed(2)}, Long: ${normalizedLong.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '€${campSite.pricePerNight.toStringAsFixed(2)} / night',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}