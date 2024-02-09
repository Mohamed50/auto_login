import 'dart:developer';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

enum ConfigurationState { checking, bluetoothNotGranted, bluetoothNotOpened, locationNotGranted, locationNotOpened, completed }

class SplashViewModel extends GetxController {
  final Rx<ConfigurationState> _state = ConfigurationState.checking.obs;

  ConfigurationState get state => _state.value;

  Future initialize() async {
    if (await _checkLocationPermission() && await _checkLocationAlwaysPermission() && await _checkIfLocationOpened()) {
      _state.value = ConfigurationState.completed;
    }
  }

  Future<bool> _checkLocationPermission() async {
    final status = await Permission.location.request();
    log('_checkLocationPermission: ${status.name}');
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      _state.value = ConfigurationState.locationNotGranted;
      return false;
    } else {
      _state.value = ConfigurationState.locationNotGranted;
      return false;
    }
  }

  Future<bool> _checkLocationAlwaysPermission() async {
    final status = await Permission.locationAlways.request();
    log('_checkLocationAlwaysPermission: ${status.name}');
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      _state.value = ConfigurationState.locationNotGranted;
      return false;
    } else {
      _state.value = ConfigurationState.locationNotGranted;
      return false;
    }
  }

  Future<bool> _checkIfLocationOpened() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      return true;
    } else {
      _state.value = ConfigurationState.locationNotOpened;
      return false;
    }
  }

  void checking() {
    _state.value = ConfigurationState.checking;
  }

  void skip() {
    _state.value = ConfigurationState.completed;
  }
}
