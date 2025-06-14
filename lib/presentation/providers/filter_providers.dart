import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

final tabIndexProvider = StateProvider<int>((ref) => 0);
final searchTextProvider = StateProvider<String>((ref) => '');
final closeToWaterProvider = StateProvider<bool>((ref) => false);
final campFireAllowedProvider = StateProvider<bool>((ref) => false);
final createdAfterDateProvider = StateProvider<DateTime?>((ref) => null);
final locationProximityProvider = StateProvider<Map<String, double>?>((ref) => null);
final hostLanguagesProvider = StateProvider<List<String>>((ref) => []);
final suitableForProvider = StateProvider<List<String>>((ref) => []);
final priceLevelsProvider = StateProvider<List<String>>((ref) => []);
final focusedCoordinateProvider = StateProvider<LatLng?>((ref) => null);