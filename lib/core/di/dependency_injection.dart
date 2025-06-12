import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/camp_site_remote_datasource.dart';
import '../../data/repositories/camp_site_repository_impl.dart';
import '../../domain/repositories/camp_site_repository.dart';
import '../../domain/usecases/get_camp_sites.dart';

final campSiteRemoteDataSourceProvider = Provider<CampSiteRemoteDataSource>(
      (ref) => CampSiteRemoteDataSource(),
);

final campSiteRepositoryProvider = Provider<CampSiteRepository>(
      (ref) => CampSiteRepositoryImpl(
    remoteDataSource: ref.read(campSiteRemoteDataSourceProvider),
  ),
);

final getCampSitesUseCaseProvider = Provider<GetCampSites>(
      (ref) => GetCampSites(
    repository: ref.read(campSiteRepositoryProvider),
  ),
);