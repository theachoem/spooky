// ignore_for_file: avoid_print, depend_on_referenced_packages

// This script fetches localization data and generates translation files for your app.
// To run, use:
// ```
// dart bin/localization/build.dart
// ```
// It performs the following tasks:
// 1. Fetches CSV data from Google Sheets (or uses a local data.csv).
// 2. Creates JSON translation files for each locale (e.g., en.json, km.json).
// 3. Updates the Info.plist file for iOS with the supported locales.
// 4. Adds locale constants to lib/core/constants/locale_constants.dart for app to use.

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:xml/xml.dart';

const String editUrl =
    "https://docs.google.com/spreadsheets/d/1XcohOqNzrkMJnAmAuJssa0Rc7wftjfN2rrxb4GgcE9c/edit?gid=654733603#gid=654733603";

const String publicCsvUrl =
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vTlTQdinMVbZEL6EQzBs2zNtfldSnCtXA9YhegOe4CCoOA5FxXYmEp_t4joa_mIVgPVI5RaY_YNCGxa/pub?gid=654733603&single=true&output=csv";

void main() async {
  final csvString = await _fetchCsvRaw();
  final csvData = CsvToListConverter().convert(csvString);
  final transposedCsvData = _transposeCsv(csvData);

  if (await Directory('translations').exists()) {
    await Directory('translations').delete(recursive: true);
    await Directory('translations').create();
  }

  List<String> locales = [];
  Map<String, String> languageNames = {};
  Map<String, String> nativeLanguageNames = {};

  for (var i = 1; i < transposedCsvData.length; i++) {
    final locale = transposedCsvData[i][0];
    final languageName = transposedCsvData[i][1];
    final nativeLanguageName = transposedCsvData[i][2];
    final file = File("translations/$locale.json");

    locales.add(locale);
    languageNames[locale] = languageName;
    nativeLanguageNames[locale] = nativeLanguageName;

    Map<String, String> map = {};

    for (var j = 0; j < transposedCsvData[i].length; j++) {
      final key = transposedCsvData[0][j];
      final value = transposedCsvData[i][j];
      map[key] = value;
    }

    await file.writeAsString(
      "${JsonEncoder.withIndent('  ').convert(map)}\n",
    );
  }

  await setBundleLocalizationToInfoPlist(locales);
  await addLangageNameToAppConstant(locales, languageNames, nativeLanguageNames);
}

Future<void> setBundleLocalizationToInfoPlist(List<String> locales) async {
  final plistFile = File('ios/Runner/Info.plist');
  final document = XmlDocument.parse(await plistFile.readAsString());

  for (XmlNode node in document.children) {
    for (XmlNode child in node.children) {
      for (XmlNode innerChild in child.children) {
        if (innerChild.innerText == 'CFBundleLocalizations') {
          innerChild.nextElementSibling?.children.clear();
          final newChildren = locales.map((locale) => XmlElement(XmlName('string'))..innerText = locale);
          innerChild.nextElementSibling?.children.addAll(newChildren);
        }
      }
    }
  }

  final newDocument = document
      .toXmlString(pretty: true, indent: '    ')
      .replaceAll("<true/>", "<true />")
      .replaceAll("<false/>", "<false />");

  await plistFile.writeAsString(newDocument);
}

Future<void> addLangageNameToAppConstant(
  List<String> locales,
  Map<String, String> languageNames,
  Map<String, String> nativeLanguageNames,
) async {
  File file = File('lib/core/constants/locale_constants.dart');

  var supportedLocales = locales.map((locale) {
    final data = locale.split("-");

    return "  Locale(${[
      '"${data.first}"',
      if (data.length > 1) '"${data.last}"',
    ].join(", ")})";
  });

  final contents = '''
// Generated by bin/localization/build.dart
import 'dart:ui';

const kFallbackLocale = Locale("en");

const kSupportedLocales = [
${supportedLocales.join(",\n")}
];

const kLanguageNames = ${JsonEncoder.withIndent('  ').convert(languageNames)};

const kNativeLanguageNames = ${JsonEncoder.withIndent('  ').convert(nativeLanguageNames)};
''';

  file.writeAsString(contents);
}

// Delete data.csv to refresh data from Google Drive.
Future<String> _fetchCsvRaw() async {
  final file = File('bin/localization/data.csv');

  if (await file.exists()) {
    return file.readAsString();
  }

  final response = await http.get(Uri.parse(publicCsvUrl));
  if (response.statusCode != 200) throw response.statusCode;

  final decodedBody = utf8.decode(response.bodyBytes);
  await file.writeAsString(decodedBody);

  return decodedBody;
}

List<List<dynamic>> _transposeCsv(List<List<dynamic>> rows) {
  List<List<dynamic>> transposed = [];

  for (int col = 0; col < rows[0].length; col++) {
    List<dynamic> newRow = [];
    for (int row = 0; row < rows.length; row++) {
      newRow.add(rows[row][col]);
    }
    transposed.add(newRow);
  }
  return transposed;
}
