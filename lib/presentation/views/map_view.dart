import 'package:campsite/core/utils/location_utils.dart';
import 'package:campsite/presentation/providers/filter_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../providers/camp_site_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

    final focusedCoordinate = ref.watch(focusedCoordinateProvider);

    if (focusedCoordinate != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(focusedCoordinate, 15); // zoom level 15
        ref.read(focusedCoordinateProvider.notifier).state = null; // Reset after move
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Campsites Map',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: campSitesAsync.when(
          data: (campSites) {
            final markers = campSites.map((campSite) {
              final normalizedLat = LocationUtils.normalizeLatitude(campSite.geoLocation.lat);
              final normalizedLong = LocationUtils.normalizeLongitude(campSite.geoLocation.long);
              return Marker(
                width: 48,
                height: 48,
                point: LatLng(normalizedLat, normalizedLong),
                child: GestureDetector(
                  onTap: () async {
                    final lat = normalizedLat;
                    final long = normalizedLong;
                    Uri uri;
                    if (kIsWeb) {
                      uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$long');
                    } else {
                      uri = Uri.parse('geo:$lat,$long?q=$lat,$long');
                    }

                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not launch Maps')),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.white,
                      size: 32,
                      semanticLabel: 'Campsite location',
                    ),
                  ),
                ),
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
                  if (!mapReady && markers.isNotEmpty) {
                    final bounds = LatLngBounds.fromPoints(
                      markers.map((m) => m.point).toList(),
                    );
                    _mapController.fitCamera(
                      CameraFit.bounds(
                        bounds: bounds,
                        padding: const EdgeInsets.all(50),
                        maxZoom: 15,
                      ),
                    );
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
                  retinaMode: true,
                ),
                if (mapReady && markers.isNotEmpty)
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      markers: markers,
                      maxClusterRadius: 50,
                      size: const Size(48, 48),
                      alignment: Alignment.center,
                      animationsOptions: const AnimationsOptions(
                        zoom: Duration(milliseconds: 400),
                        spiderfy: Duration(milliseconds: 400),
                      ),
                      builder: (context, clusterMarkers) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
                          ),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            clusterMarkers.length.toString(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
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
          loading: () => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Oops! Something went wrong:\n$error',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
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