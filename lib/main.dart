import 'dart:developer';
import 'package:auto_login/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:latlong2/latlong.dart';
import 'src/app.dart';
import 'src/data/services/memory_service.dart';
import 'src/modules/foreground_service/foreground_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MemoryService.instance.initialize();
  RouteManager.instance.initialize();
  runApp(const App());
}

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  log('Start callback called');
  WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.setTaskHandler(AutoLoginTaskHandler());
}

