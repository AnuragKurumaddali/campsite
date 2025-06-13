import 'package:campsite/data/models/camp_site_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CampSiteRemoteDataSource {
  final http.Client client;

  CampSiteRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

  Future<List<CampSiteModel>> getCampSites() async {
    final response = await client.get(Uri.parse('https://62ed0389a785760e67622eb2.mockapi.io/spots/v1/campsites'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CampSiteModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load campsites: ${response.statusCode}');
    }
  }
}