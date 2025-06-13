import 'package:campsite/core/utils/location_utils.dart';
import 'package:campsite/domain/entities/camp_site.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailView extends StatelessWidget {
  final CampSite campSite;
  const DetailView({super.key, required this.campSite});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalizedLat = LocationUtils.normalizeLatitude(campSite.geoLocation.lat);
    final normalizedLong = LocationUtils.normalizeLongitude(campSite.geoLocation.long);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          campSite.label,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: campSite.id,
              child: ClipRRect(
                child: Image.network(
                  campSite.photo,
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 280,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campSite.label,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '€${campSite.pricePerNight.toStringAsFixed(2)} / night',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _InfoRow(
                    icon: Icons.water,
                    label: 'Close to Water',
                    value: campSite.isCloseToWater ? 'Yes' : 'No',
                    iconColor: campSite.isCloseToWater ? Colors.blueAccent : Colors.grey,
                  ),
                  _InfoRow(
                    icon: Icons.local_fire_department,
                    label: 'Campfire Allowed',
                    value: campSite.isCampFireAllowed ? 'Yes' : 'No',
                    iconColor: campSite.isCampFireAllowed ? Colors.orange : Colors.grey,
                  ),
                  _InfoRow(
                    icon: Icons.language,
                    label: 'Host Languages',
                    value: campSite.hostLanguages.join(', '),
                  ),
                  _InfoRow(
                    icon: Icons.location_on,
                    label: 'Location',
                    value:
                    'Lat ${normalizedLat.toStringAsFixed(2)}, Long ${normalizedLong.toStringAsFixed(2)}',
                  ),
                  _InfoRow(
                    icon: Icons.calendar_today,
                    label: 'Listed Since',
                    value: DateFormat('MMM d, yyyy').format(campSite.createdAt),
                  ),
                  _InfoRow(
                    icon: Icons.directions_run,
                    label: 'Suitable For',
                    value: campSite.suitableFor.join(', '),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: iconColor ?? theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}