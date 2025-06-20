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

  static Future<List<List<dynamic>>> loadBaseRateData({
  required String type,
  required String village,
  required String locality,
  required String taluka,
  required String district,
  required String state,
}) async {
    class BaseRateRecord {
  final String village;
  final String locality;
  final String taluka;
  final String district;
  final String state;
  final double baseRate;

  BaseRateRecord({
    required this.village,
    required this.locality,
    required this.taluka,
    required this.district,
    required this.state,
    required this.baseRate,
  });

  factory BaseRateRecord.fromMap(Map<String, String> m) {
    return BaseRateRecord(
      village: m['Village']?.trim() ?? 'N/A',
      locality: m['Locality']?.trim() ?? 'N/A',
      taluka: m['Taluka']?.trim() ?? 'N/A',
      district: m['District']?.trim() ?? 'N/A',
      state: m['State']?.trim() ?? 'N/A',
      baseRate: double.tryParse(m['Base Rate'] ?? '') ?? 0.0,
    );
  }
  @override
  String toString() {
    return 'BaseRateRecord(village: $village, locality: $locality, taluka: $taluka, district: $district, state: $state, baseRate: $baseRate)';
  }
}
Future<double?> getBaseRate({
  required String type,
  String? village,
  String? locality,
  String? taluka,
  String? district,
  String? state,
}) async {
  const sheetId = '1E_qT-HrCflBh78wXS6PTvJyffQOmnJalXwVotcVrXzg';
  const gidMap = {
    'Flat': '0',
    'Office': '560020132',
    'Shop': '286517898',
  };

  final gid = gidMap[type];
  if (gid == null) {
    throw ArgumentError('Invalid type: $type. Must be Flat, Office, or Shop.');
  }

  final url = Uri.parse(
    'https://docs.google.com/spreadsheets/d/$sheetId/export?format=csv&gid=$gid',
  );
  final resp = await http.get(url);
  if (resp.statusCode != 200) {
    throw Exception('Failed to load CSV: ${resp.statusCode}');
  }


  final rows = const CsvToListConverter(
    eol: '\r\n',
    shouldParseNumbers: false,
    fieldDelimiter: ',',
  ).convert(resp.body);
  if (rows.isEmpty) return null;
  
  final headers = rows.first.map((h) => h.toString()).toList();
  final dataRows = rows.skip(1);
  
  final records = dataRows.map((row) {
    final map = <String, String>{};
    for (var i = 0; i < headers.length; i++) {
      map[headers[i]] = row[i]?.toString() ?? '';
    }
    
    return BaseRateRecord.fromMap(map);
  }).toList();
  
  final filtered = records.where((r) {
    if (village != null && r.village != village) return false;
    if (locality != null && r.locality != locality) return false;
    if (taluka != null && r.taluka != taluka) return false;
    if (district != null && r.district != district) return false;
    if (state != null && r.state != state) return false;
    return true;
  });
  final match = filtered.isNotEmpty ? filtered.first : null;
  return match?.baseRate;
}
    final rate = await getBaseRate(
      type: type,
      village: village,
      locality: locality,
      taluka: taluka,
      district: district,
      state: state,
    );
    return rate.toStringAsFixed(2)
  }
}
