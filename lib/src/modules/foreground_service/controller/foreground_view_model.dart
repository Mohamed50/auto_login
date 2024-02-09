import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:auto_login/main.dart';
import 'package:auto_login/src/modules/foreground_service/foreground_service.dart';
import 'package:auto_login/src/utils/utils.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';

class ForegroundViewModel extends GetxController {
  final ForegroundServiceManager _manager;
  ReceivePort? _receivePort;

  final RxBool _isServiceRunning = false.obs;

  bool get isServiceRunning => _isServiceRunning.value;

  final Rx<Map<String, dynamic>> _messages = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get  messages => _messages.value;

  ForegroundViewModel(this._manager){
    _initialize();
  }

  Future _initialize() async {
    await _requestPermissionForAndroid();
    _manager.initialize();
    _isServiceRunning.value = await FlutterForegroundTask.isRunningService;
    if (isServiceRunning) {
      final newReceivePort = FlutterForegroundTask.receivePort;
      _registerReceivePort(newReceivePort);
    }
  }

  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }

    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      // This function requires `android.permission.SYSTEM_ALERT_WINDOW` permission.
      await FlutterForegroundTask.openSystemAlertWindowSettings();
    }

    // Android 12 or higher, there are restrictions on starting a foreground service.
    //
    // To restart the service on device reboot or unexpected problem, you need to allow below permission.
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    // Android 13 and higher, you need to allow notification permission to expose foreground service notification.
    final NotificationPermission notificationPermissionStatus = await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermissionStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  Future startForegroundTask() async {
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

    // Register the receivePort before starting the service.
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      log('Failed to register receivePort!');
      return false;
    }

    if (isServiceRunning) {
      return FlutterForegroundTask.restartService();
    } else {
      if (await FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      )) {
        _running();
      }
    }
  }

  Future stopForegroundTask() async {
    if (await FlutterForegroundTask.stopService()) {
      _notRunning();
    }
  }

  void _running() {
    _isServiceRunning.value = true;
  }

  void _notRunning() {
    _isServiceRunning.value = false;
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((data) {
      log('Receive Port Message: $data');
      if (data is String) {
        if (data == 'onNotificationPressed') {
          Get.toNamed(RouteManager.homeRoute);
        }
      }
      else if(data is Map){
        _messages.value = data as Map<String, dynamic>;
      }
    });

    return _receivePort != null;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  @override
  void onClose() {
    _closeReceivePort();
    super.onClose();
  }
}
