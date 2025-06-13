import 'package:campsite/domain/entities/camp_site.dart';
import 'package:campsite/domain/repositories/camp_site_repository.dart';
import 'package:campsite/domain/usecases/get_camp_sites.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'get_camp_sites_test.mocks.dart';

@GenerateMocks([CampSiteRepository])
void main() {
  late GetCampSites useCase;
  late MockCampSiteRepository mockRepository;

  setUp(() {
    mockRepository = MockCampSiteRepository();
    useCase = GetCampSites(repository: mockRepository);
  });

  final tCampSite = CampSite(
    id: '1',
    label: 'Test Campsite',
    photo: 'https://example.com/photo.jpg',
    geoLocation: GeoLocation(lat: 45.0, long: -75.0),
    isCloseToWater: true,
    isCampFireAllowed: false,
    hostLanguages: ['en'],
    pricePerNight: 50.0,
    suitableFor: ['Hiking'],
    createdAt: DateTime(2023, 1, 1),
  );

  group('GetCampSites', () {
    test('should return a list of CampSite from the repository', () async {

      when(mockRepository.getCampSites()).thenAnswer(
            (_) async => [tCampSite],
      );


      final result = await useCase.call();


      expect(result, equals([tCampSite]));
      verify(mockRepository.getCampSites()).called(1);
    });

    test('should throw an Exception when the repository fails', () async {

      when(mockRepository.getCampSites()).thenThrow(Exception('Repository Error'));


      final call = useCase.call;


      expect(call(), throwsA(isA<Exception>()));
      verify(mockRepository.getCampSites()).called(1);
    });
  });
}