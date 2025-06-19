import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';

class DataProvider {
  static const String _sheetId = "1E_qT-HrCflBh78wXS6PTvJyffQOmnJalXwVotcVrXzg";
  static const Map<String, String> _gids = {
    "Flat": "0",
    "Office": "560020132",
    "Shop": "286517898",
  };

  static Future<Map<String, List<List<dynamic>>>> loadBaseRateData() async {
    Map<String, List<List<dynamic>>> data = {};
    for (String name in _gids.keys) {
      final gid = _gids[name];
      final url =
          "https://docs.google.com/spreadsheets/d/$_sheetId/export?format=csv&gid=$gid";
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final csvData = const CsvToListConverter().convert(response.body);
          data[name] = csvData;
        } else {
          throw Exception('Failed to load data for $name');
        }
      } catch (e) {
        log('Failed to load data for $name: $e');
        data[name] = [];
      }
    }
    return data;
  }
}
