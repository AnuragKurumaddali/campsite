class GeoLocation {
  final double lat;
  final double long;
  GeoLocation({required this.lat, required this.long});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GeoLocation &&
              runtimeType == other.runtimeType &&
              lat == other.lat &&
              long == other.long;

  @override
  int get hashCode => Object.hash(lat, long);
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CampSite &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              label == other.label &&
              photo == other.photo &&
              geoLocation == other.geoLocation &&
              isCloseToWater == other.isCloseToWater &&
              isCampFireAllowed == other.isCampFireAllowed &&
              hostLanguages == other.hostLanguages &&
              pricePerNight == other.pricePerNight &&
              suitableFor == other.suitableFor &&
              createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    label,
    photo,
    geoLocation,
    isCloseToWater,
    isCampFireAllowed,
    hostLanguages,
    pricePerNight,
    suitableFor,
    createdAt,
  );
}