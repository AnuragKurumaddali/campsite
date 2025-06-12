import '../../domain/entities/camp_site.dart';

class GeoLocationModel {
  final double lat;
  final double long;
  GeoLocationModel({required this.lat, required this.long});

  factory GeoLocationModel.fromJson(Map<String, dynamic> json) {
    double lat = json['lat'];
    double long = json['long'];
    lat = (lat % 180) - 90;
    long = (long % 360) - 180;
    return GeoLocationModel(lat: lat, long: long);
  }

  GeoLocation toEntity() => GeoLocation(lat: lat, long: long);
}

class CampSiteModel {
  final String id;
  final String label;
  final String photo;
  final GeoLocationModel geoLocation;
  final bool isCloseToWater;
  final bool isCampFireAllowed;
  final List<String> hostLanguages;
  final double pricePerNight;
  final List<String> suitableFor;
  final DateTime createdAt;

  CampSiteModel({
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

  factory CampSiteModel.fromJson(Map<String, dynamic> json) {
    return CampSiteModel(
      id: json['id'],
      label: json['label'],
      photo: json['photo'],
      geoLocation: GeoLocationModel.fromJson(json['geoLocation']),
      isCloseToWater: json['isCloseToWater'],
      isCampFireAllowed: json['isCampFireAllowed'],
      hostLanguages: List<String>.from(json['hostLanguages']),
      pricePerNight: json['pricePerNight'].toDouble(),
      suitableFor: List<String>.from(json['suitableFor']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  CampSite toEntity() => CampSite(
    id: id,
    label: label,
    photo: photo,
    geoLocation: geoLocation.toEntity(),
    isCloseToWater: isCloseToWater,
    isCampFireAllowed: isCampFireAllowed,
    hostLanguages: hostLanguages,
    pricePerNight: pricePerNight,
    suitableFor: suitableFor,
    createdAt: createdAt,
  );
}