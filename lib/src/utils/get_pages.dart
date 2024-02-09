import 'package:auto_login/src/modules/home/home_bindings.dart';
import 'package:auto_login/src/modules/home/view/home.dart';
import 'package:get/get.dart';
import '../modules/splash/splash.dart';
import 'binding.dart';


class RouteManager {
  static final RouteManager _mInstance = RouteManager._();
  static RouteManager get instance => _mInstance;

  List<GetPage> _pages = [];
  List<GetPage> get pages => _pages;

  RouteManager._();

  static const String initialRoute = '/';
  static const String homeRoute = '/home';


  void initialize() {
    _pages = [
      GetPage(name: initialRoute, page: () => const SplashPage(), binding: InitialBindings()),
      GetPage(name: homeRoute, page: () => const HomePage(), binding: HomeBindings()),
    ];
  }
}
