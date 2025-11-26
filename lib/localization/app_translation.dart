import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AppTranslation extends Translations {
  static Map<String, String> enUS = {};
  static Map<String, String> frFR = {};

  static Future<void> init() async {
    enUS = Map<String, String>.from(
      json.decode(await rootBundle.loadString('lib/localization/en_US.json')),
    );

    frFR = Map<String, String>.from(
      json.decode(await rootBundle.loadString('lib/localization/fr_FR.json')),
    );
  }

  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'fr_FR': frFR};
}
