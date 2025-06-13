import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:campsite/data/datasources/remote/camp_site_remote_datasource.dart';
import 'package:campsite/data/models/camp_site_model.dart';
import 'package:campsite/data/repositories/camp_site_repository_impl.dart';
import 'camp_site_repository_impl_test.mocks.dart';

@GenerateMocks([CampSiteRemoteDataSource])
void main() {
  late CampSiteRepositoryImpl repository;
  late MockCampSiteRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockCampSiteRemoteDataSource();
    repository = CampSiteRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

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

  final tCampSite = tCampSiteModel.toEntity();

  group('getCampSites', () {
    test('should return a list of CampSite entities when the data source returns models', () async {

      when(mockRemoteDataSource.getCampSites()).thenAnswer(
            (_) async => [tCampSiteModel],
      );


      final result = await repository.getCampSites();

      expect(result, equals([tCampSite]));
      verify(mockRemoteDataSource.getCampSites()).called(1);
    });

    test('should throw an Exception when the data source fails', () async {

      when(mockRemoteDataSource.getCampSites()).thenThrow(Exception('API Error'));


      final call = repository.getCampSites;


      expect(() => call(), throwsA(isA<Exception>()));
      verify(mockRemoteDataSource.getCampSites()).called(1);
    });
  });
}