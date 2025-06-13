import 'package:campsite/core/utils/location_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../providers/camp_site_provider.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  final MapController _mapController = MapController();
  bool mapReady = false;

  @override
  Widget build(BuildContext context) {
    final campSitesAsync = ref.watch(campSitesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campsites Map'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 1,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: campSitesAsync.when(
        data: (campSites) {
          final markers = campSites.map((campSite) {
            final normalizedLat = LocationUtils.normalizeLatitude(campSite.geoLocation.lat);
            final normalizedLong = LocationUtils.normalizeLongitude(campSite.geoLocation.long);
            return Marker(
              width: 40,
              height: 40,
              point: LatLng(normalizedLat, normalizedLong),
              child: const Icon(Icons.location_on, color: Colors.red, size: 36),
            );
          }).toList();

          const LatLng fallbackCenter = LatLng(20, 0);

          LatLng center = markers.isNotEmpty
              ? LatLng(
            markers.map((m) => m.point.latitude).reduce((a, b) => a + b) / markers.length,
            markers.map((m) => m.point.longitude).reduce((a, b) => a + b) / markers.length,
          )
              : fallbackCenter;

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 3,
              minZoom: 2,
              maxZoom: 18,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom |
                InteractiveFlag.drag |
                InteractiveFlag.flingAnimation |
                InteractiveFlag.doubleTapZoom |
                InteractiveFlag.scrollWheelZoom,
              ),
              cameraConstraint: CameraConstraint.contain(
                bounds: LatLngBounds(
                  const LatLng(-85.0, -180.0),
                  const LatLng(85.0, 180.0),
                ),
              ),
              onMapReady: () {
                if (!mapReady) {
                  setState(() {
                    mapReady = true;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.vajra.camp',
              ),
              if (mapReady && markers.isNotEmpty)
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    markers: markers,
                    maxClusterRadius: 45,
                    size: const Size(40, 40),
                    alignment: Alignment.center,
                    builder: (context, clusterMarkers) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary,
                      ),
                      child: Center(
                        child: Text(
                          clusterMarkers.length.toString(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Oops! Something went wrong:\n$error',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}