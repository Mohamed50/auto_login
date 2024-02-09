import 'package:auto_login/src/modules/foreground_service/controller/foreground_view_model.dart';
import 'package:auto_login/src/modules/foreground_service/foreground_service.dart';
import 'package:auto_login/src/modules/home/controller/configuration_view_model.dart';
import 'package:get/get.dart';

class HomeBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => ConfigurationViewModel());
    Get.lazyPut(() => ForegroundViewModel(ForegroundServiceManager.instance));
  }

}