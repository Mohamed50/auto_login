import 'package:auto_login/src/config/app_exception.dart';
import 'package:auto_login/src/config/config.dart';
import 'package:get/get.dart';

import 'splash.dart';

class SplashActions {
  static final SplashActions _mInstance = SplashActions._();

  static SplashActions get instance => _mInstance;

  SplashActions._();

  Future<void> initSplash(String nextRouteString, int delayInSeconds) async {
    try {
      final controller = Get.find<SplashViewModel>();
      controller.checking();
      await Future.delayed(Duration(seconds: delayInSeconds));
      await controller.initialize();
      if (controller.state == ConfigurationState.completed) {
        Get.offNamed(nextRouteString);
      }
    } on NetworkException catch (e) {
      Get.snackbar(e.prefix.tr, e.message.tr);
    } on Exception {
      Get.snackbar(tkErrorTitle.tr, tkSomethingWentWrongMessage.tr);
    }
  }

  Future<void> skip(String nextRouteString, int delayInSeconds) async {
    try {
      final controller = Get.find<SplashViewModel>();
      controller.checking();
      await Future.delayed(Duration(seconds: delayInSeconds));
      controller.skip();
      if (controller.state == ConfigurationState.completed) {
        Get.offNamed(nextRouteString);
      }
    } on NetworkException catch (e) {
      Get.snackbar(e.prefix.tr, e.message.tr);
    } on Exception {
      Get.snackbar(tkErrorTitle.tr, tkSomethingWentWrongMessage.tr);
    }
  }
}
