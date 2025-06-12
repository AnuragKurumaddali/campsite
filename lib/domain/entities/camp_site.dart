class GeoLocation {
  final double lat;
  final double long;
  GeoLocation({required this.lat, required this.long});
}

class CampSite {
  final String id;
  final String label;
  final String photo;
  final GeoLocation geoLocation;
  final bool isCloseToWater;
  final bool isCampFireAllowed;
  final List<String> hostLanguages;
  final double pricePerNight;
  final List<String> suitableFor;
  final DateTime createdAt;

  CampSite({
    required this.id,
    required this.label,
    required this.photo,
    required this.geoLocation,
    required this.isCloseToWater,
    required this.isCampFireAllowed,
    required this.hostLanguages,
    required this.pricePerNight,
    required this.suitableFor,
    required this.createdAt,
  });
}