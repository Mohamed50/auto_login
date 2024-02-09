import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:get/get.dart';
import '/src/utils/get_pages.dart';
import '/src/config/config.dart';
import '/src/modules/locale/localization_service.dart';
import '/src/utils/binding.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: (_)=> const Center(
        child: SpinKitCubeGrid(
          color: Colors.white,
          size: 50.0,
        ),
      ),
      child: GetMaterialApp(
        initialBinding: InitialBindings(),
        getPages: RouteManager.instance.pages,
        translations: LocalizationService(),
        locale: LocalizationService.locale,
        fallbackLocale: LocalizationService.fallbackLocale,
        theme: theme,
      ),
    );
  }

}
