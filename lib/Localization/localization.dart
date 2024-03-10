import 'package:cph_stocks/Localization/en_IN.dart';
import 'package:cph_stocks/Localization/gu_IN.dart';
import 'package:cph_stocks/Localization/hi_IN.dart';
import 'package:get/get.dart';

class Localization extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'en_IN': enIN,
      'hi_IN': hiIN,
      'gu_IN': guIN,
    };
  }
}
