import '../entities/camp_site.dart';

abstract class CampSiteRepository {
  Future<List<CampSite>> getCampSites();
}