import 'package:campsite/core/di/dependency_injection.dart';
import 'package:campsite/domain/entities/camp_site.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final campSitesProvider = FutureProvider<List<CampSite>>((ref) async {
  return await ref.watch(getCampSitesUseCaseProvider).call();
});