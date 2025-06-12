import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/camp_site_model.dart';

class CampSiteRemoteDataSource {
  final String apiUrl = 'https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites';

  Future<List<CampSiteModel>> getCampSites() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => CampSiteModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load campsites');
    }
  }
}