import 'dart:convert';
import 'package:campsite/data/datasources/remote/camp_site_remote_datasource.dart';
import 'package:campsite/data/models/camp_site_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'camp_site_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late CampSiteRemoteDataSource dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = CampSiteRemoteDataSource(client: mockHttpClient);
  });

  const String apiUrl = 'https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites';

  final tCampSiteModel = CampSiteModel(
    id: '1',
    label: 'Test Campsite',
    photo: 'https://example.com/photo.jpg',
    geoLocation: const GeoLocationModel(lat: 45.0, long: -75.0),
    isCloseToWater: true,
    isCampFireAllowed: false,
    hostLanguages: const ['en'],
    pricePerNight: 50.0,
    suitableFor: const ['Hiking'],
    createdAt: DateTime.utc(2023, 1, 1),
  );

  final tJsonResponse = [
    {
      'id': '1',
      'label': 'Test Campsite',
      'photo': 'https://example.com/photo.jpg',
      'geoLocation': {'lat': 45.0, 'long': -75.0},
      'isCloseToWater': true,
      'isCampFireAllowed': false,
      'hostLanguages': ['en'],
      'pricePerNight': 50.0,
      'suitableFor': ['Hiking'],
      'createdAt': '2023-01-01T00:00:00Z',
    }
  ];

  group('getCampSites', () {
    test('should return a list of CampSiteModel when the API call is successful', () async {

      when(mockHttpClient.get(Uri.parse(apiUrl))).thenAnswer(
            (_) async {
          return http.Response(json.encode(tJsonResponse), 200);
        },
      );


      final result = await dataSource.getCampSites();


      expect(result, equals([tCampSiteModel]));
      verify(mockHttpClient.get(Uri.parse(apiUrl))).called(1);
    });

    test('should throw an Exception when the API call fails', () async {

      when(mockHttpClient.get(Uri.parse(apiUrl))).thenAnswer(
            (_) async => http.Response('Not Found', 404),
      );


      final call = dataSource.getCampSites;


      expect(() => call(), throwsA(isA<Exception>()));
      verify(mockHttpClient.get(Uri.parse(apiUrl))).called(1);
    });
  });
}