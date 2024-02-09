import 'dart:ui';
import 'package:get/get.dart';
import 'lang/lang_en.dart';
import '/src/data/services/memory_service.dart';

class LocalizationService extends Translations {
  static const fallbackLocale = Locale('en');
  static Locale? _locale = Get.deviceLocale;

  static Locale get locale {
    return _locale ?? fallbackLocale;
  }

  static init() {
    String? languageCode = MemoryService.instance.languageCode;
    if (languageCode != null) {
      _updateLocale(languageCode);
    }
  }

  static _saveLocale(String languageCode) {
    MemoryService.instance.languageCode = languageCode;
  }

  static _updateLocale(String languageCode) {
    _locale = Locale(languageCode);
    Get.updateLocale(_locale!);
  }

  static changeLocale(String languageCode){
    _updateLocale(languageCode);
    _saveLocale(languageCode);
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en': englishTranslationsMap,
      };
}
