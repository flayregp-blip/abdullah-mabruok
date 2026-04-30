import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class Country {
  String countryCode;
  String countryName;
  String phoneCode;

  Country({
    required this.countryCode,
    required this.countryName,
    required this.phoneCode,
  });

  @override
  String toString() {
    return 'Country(countryCode: $countryCode, countryName: $countryName, phoneCode: $phoneCode)';
  }
}

// Helper Functions
Future<List<T>> parseCsv<T>(
  String filePath,
  T Function(List<dynamic> row) factoryFunction,
) async {
  final content = await rootBundle.loadString(filePath);
  final rows = const CsvToListConverter().convert(content, eol: '\n');
  return rows.skip(1).map((row) => factoryFunction(row)).toList();
}

Future<List<Country>> parseCountries({required String filePath}) {
  return parseCsv(
    filePath,
    (row) => Country(
      countryCode: row[0],
      countryName: row[1],
      phoneCode: row[2] is int ? '+${row[2]}' : row[2],
    ),
  );
}
