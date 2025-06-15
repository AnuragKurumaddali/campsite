# Campsite Finder

A Flutter app to browse and explore campsites. View campsites in a list or grid, filter them by various attributes, see details of each campsite, and locate them on a map with clustering. The app is built with a clean, user-friendly design and works on web, Android, and iOS.

Hosted at: [https://anuragkurumaddali.github.io/campsite/](https://anuragkurumaddali.github.io/campsite/)

## Features

- **Home View**: Browse campsites in a list or grid layout, with a toggle to switch between views.
- **Filters**: Narrow down campsites by creation date, location proximity, host languages, suitable activities, and price levels.
- **Search**: Search campsites by name for quick access.
- **Detail View**: View detailed information about a campsite, including price, location, amenities, and more.
- **Map View**: See all campsites on an interactive map with marker clustering. Tap markers to open navigation in Google Maps.
- **Smooth UI**: Enjoy animations, scroll hints, and a modern Material 3 design.
- **State Management**: Uses Riverpod for efficient and reactive state management.
- **Cross-Platform**: Runs seamlessly on web, Android, and iOS.

## App Structure

```
lib/
├── core/
│   ├── di/
│   │   └── dependency_injection.dart
│   └── utils/
│       └── location_utils.dart
├── data/
│   └── datasources/
│   │   └── datasources/
│   │   │       └── camp_site_remote_datasource.dart
│   └── models/
│       └── camp_site_model.dart
│   └── repositories/
│       └── camp_site_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── camp_site.dart
│   ├── repositories/
│   │   └── camp_site_repository.dart
│   └── usecases/
│       └── get_camp_sites.dart
├── presentation/
│   ├── providers/
│   │   ├── camp_site_provider.dart
│   │   └── filter_providers.dart
│   ├── views/
│   │   ├── widgets/
│   │      ├── camp_site_card.dart
│   │      ├── feature_icon.dart
│   │      ├── filters_row.dart
│   │      ├── location_filter_dialog.dart
│   │      ├── languages_filter_dialog.dart
│   │      ├── price_level_filter_dialog.dart
│   │      ├── suitable_filter_dialog.dart
│   │      └── view_toggle.dart
│   │   └── detail_view.dart
│   │   └── home_view.dart
│   │   └── main_view.dart
│   │   └── map_view.dart
└── main.dart

test/
├── data/
│   ├── datasources/
│   │   ├── camp_site_remote_datasource_test.dart
│   │   └── camp_site_remote_datasource_test.mocks.dart
│   └── repositories/
│   │   ├── camp_site_repository_impl_test.dart
│   │   └── camp_site_repository_impl_test.mocks.dart
├── domain/
│   └── use_cases/
│   │   ├── get_camp_sites_test.dart
│   │   └── get_camp_sites_test.mocks.dart
├── presentation/
│   ├── views/
│   │   ├── detail_view_test.dart
│   │   └── home_view_test.dart
│   ├── widgets/
│   │   ├── camp_site_card_test.dart
│   │   ├── languages_filter_dialog_test.dart
│   │   ├── location_filter_dialog_test.dart
│   │   ├── price_level_filter_dialog_test.dart
│   │   ├── suitable_filter_dialog_test.dart
│   │   └── view_toggle_test.dart
```

## Getting Started

### Prerequisites

- Flutter SDK (version 3.x or later)
- Dart SDK (included with Flutter)
- Android Studio or Xcode (for mobile builds)
- A web browser (for web builds)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/AnuragKurumaddali/campsite.git
   cd campsite
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the app:
   - For web:
     ```
     flutter run -d chrome
     ```
   - For Android/iOS:
     ```
     flutter run
     ```

### Building for Production

- Build for web:
  ```
  flutter build web
  ```
  The output is in `build/web/`.

- Build for Android:
  ```
  flutter build apk
  ```

- Build for iOS:
  ```
  flutter build ios
  ```

### Running Tests

Run unit tests to verify the app's functionality:
```
flutter test
```

## Data Source

The app fetches campsite data from a public API:
```
https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites
```

Campsite properties include:
- Label (name)
- GeoLocation (latitude and longitude)
- Close to water (boolean)
- Campfire allowed (boolean)
- Host languages
- Price per night (in euros)
- Suitable activities
- Photo URL
- Creation date

Invalid geocoordinates are normalized using utility functions in `location_utils.dart`.

## Dependencies

Key dependencies used in the app:
- `flutter_riverpod`: For state management
- `http`: For API requests
- `flutter_map`: For map rendering
- `flutter_map_marker_cluster`: For marker clustering
- `latlong2`: For geolocation handling
- `url_launcher`: For opening external map links
- `intl`: For date formatting

See `pubspec.yaml` for the full list.
