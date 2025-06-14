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
      margin: isGridView ? const EdgeInsets.only(bottom: 16) : const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      elevation: 8,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailView(campSite: campSite)),
        ),
        child: isGridView
            ? Stack(
          children: [
            Hero(
              tag: campSite.id,
              child: Image.network(
                campSite.photo,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
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
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(8), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campSite.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4), // Reduced spacing
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FeatureIcon(
                            icon: Icons.water,
                            isActive: campSite.isCloseToWater,
                            activeColor: Colors.blueAccent,
                          ),
                          const SizedBox(width: 4), // Reduced spacing
                          FeatureIcon(
                            icon: Icons.local_fire_department,
                            isActive: campSite.isCampFireAllowed,
                            activeColor: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4), // Reduced spacing
                    Text(
                      '€${campSite.pricePerNight.toStringAsFixed(2)} / night',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4), // Reduced spacing
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Icon(
                            size: 12, // Reduced icon size
                            color: Colors.white70,
                            Icons.location_on,
                          ),
                          const SizedBox(width: 2), // Reduced spacing
                          Text(
                            'Lat: ${normalizedLat.toStringAsFixed(2)}, Long: ${normalizedLong.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
            : SizedBox(
          height: 200, // Constrain height to fix infinite size error
          child: Stack(
            children: [
              Hero(
                tag: campSite.id,
                child: Image.network(
                  campSite.photo,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
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
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(8), // Reduced padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campSite.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4), // Reduced spacing
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            FeatureIcon(
                              icon: Icons.water,
                              isActive: campSite.isCloseToWater,
                              activeColor: Colors.blueAccent,
                            ),
                            const SizedBox(width: 4), // Reduced spacing
                            Text(
                              campSite.isCloseToWater ? 'Near Water' : 'Not Near Water',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 6), // Reduced spacing
                            FeatureIcon(
                              icon: Icons.local_fire_department,
                              isActive: campSite.isCampFireAllowed,
                              activeColor: Colors.orange,
                            ),
                            const SizedBox(width: 4), // Reduced spacing
                            Text(
                              campSite.isCampFireAllowed ? 'Campfire' : 'No Campfire',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4), // Reduced spacing
                      Row(
                        children: [
                          const Icon(
                            size: 12, // Reduced icon size
                            color: Colors.white70,
                            Icons.calendar_today,
                          ),
                          const SizedBox(width: 4), // Reduced spacing
                          Flexible(
                            child: Text(
                              'Listed: ${DateFormat('MMM d, yyyy').format(campSite.createdAt)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4), // Reduced spacing
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const Icon(
                              size: 12, // Reduced icon size
                              color: Colors.white70,
                              Icons.location_on,
                            ),
                            const SizedBox(width: 4), // Reduced spacing
                            Text(
                              'Lat: ${normalizedLat.toStringAsFixed(2)}, Long: ${normalizedLong.toStringAsFixed(2)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4), // Reduced spacing
                      Text(
                        '€${campSite.pricePerNight.toStringAsFixed(2)} / night',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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