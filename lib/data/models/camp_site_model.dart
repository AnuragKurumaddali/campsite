import 'package:equatable/equatable.dart';
import 'package:campsite/domain/entities/camp_site.dart';

class GeoLocationModel extends Equatable{
  final double lat;
  final double long;
  const GeoLocationModel({required this.lat, required this.long});

  factory GeoLocationModel.fromJson(Map<String, dynamic> json) {
    double lat = json['lat'];
    double long = json['long'];
    return GeoLocationModel(lat: lat, long: long);
  }

  GeoLocation toEntity() => GeoLocation(lat: lat, long: long);

  @override
  List<Object?> get props => [
    lat,
    long,
  ];
}

class CampSiteModel extends Equatable {
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

  const CampSiteModel({
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
      createdAt: DateTime.parse(json['createdAt']).toUtc(),
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

  @override
  List<Object?> get props => [
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
  ];
}