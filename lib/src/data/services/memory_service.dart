import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MemoryService extends GetConnect {
  static final MemoryService _mInstance = MemoryService._();

  static MemoryService get instance => _mInstance;

  late GetStorage _storage;

  MemoryService._() {
    _storage = GetStorage('auto_login');
  }

  Future initialize() async {
    await GetStorage.init('auto_login');
  }

  String? get languageCode => _storage.read("languageCode");
  set languageCode (String? languageCode) => _storage.write("languageCode", languageCode);

  double? get latitude => _storage.read("latitude");
  set latitude (double? latitude) => _storage.write("latitude", latitude);

  double? get longitude => _storage.read("longitude");
  set longitude (double? longitude) => _storage.write("longitude", longitude);

  double? get roomArea => _storage.read("roomArea");
  set roomArea (double? roomArea) => _storage.write("roomArea", roomArea);



}
