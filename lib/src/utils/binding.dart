import 'package:auto_login/src/modules/splash/splash.dart';
import 'package:get/get.dart';
import '../modules/connections/connection_view_model.dart';
import '/src/data/services/memory_service.dart';


class InitialBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ConnectionViewModel());
    Get.lazyPut(() => SplashViewModel());
  }
}