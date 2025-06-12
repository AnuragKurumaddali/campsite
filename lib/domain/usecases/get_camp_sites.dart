import '../entities/camp_site.dart';
import '../repositories/camp_site_repository.dart';

class GetCampSites {
  final CampSiteRepository repository;

  GetCampSites({required this.repository});

  Future<List<CampSite>> call() async {
    return await repository.getCampSites();
  }
}