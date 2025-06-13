import 'package:campsite/domain/entities/camp_site.dart';
import 'package:campsite/presentation/providers/camp_site_provider.dart';
import 'package:campsite/presentation/views/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

  testWidgets('MapScreen displays markers for campsites', (WidgetTester tester) async {

    final container = ProviderContainer(
      overrides: [
        campSitesProvider.overrideWith((ref) => Future.value([tCampSite])),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: MapView(),
        ),
      ),
    );


    await tester.pumpAndSettle();


    expect(find.text('Campsites Map'), findsOneWidget);
    expect(find.byIcon(Icons.location_on), findsOneWidget);
  });
}