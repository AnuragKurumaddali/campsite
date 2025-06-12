import '../../domain/entities/camp_site.dart';
import '../../domain/repositories/camp_site_repository.dart';
import '../datasources/remote/camp_site_remote_datasource.dart';
import '../models/camp_site_model.dart';

class CampSiteRepositoryImpl implements CampSiteRepository {
  final CampSiteRemoteDataSource remoteDataSource;

  CampSiteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CampSite>> getCampSites() async {
    try {
      final List<CampSiteModel> campSiteModels = await remoteDataSource.getCampSites();
      return campSiteModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch campsites: $e');
    }
  }
}