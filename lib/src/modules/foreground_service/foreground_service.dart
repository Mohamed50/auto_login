import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:fl_location/fl_location.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class ForegroundServiceManager {
  static final ForegroundServiceManager instance = ForegroundServiceManager._();

  ForegroundServiceManager._();

  void configure() {}

  void initialize() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Auto Login',
        channelDescription: 'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        showWhen: true,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 300000,
        // 5 minutes as milliseconds
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }
}

class AutoLoginTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  StreamSubscription<Location>? _streamSubscription;
  double? roomAreaInMeter;
  LatLng? roomLocation;

  AutoLoginTaskHandler() {
    initialize();
  }

  Future<void> initialize() async {
    roomAreaInMeter = await FlutterForegroundTask.getData(key: 'roomArea');
    double latitude = await FlutterForegroundTask.getData(key: 'latitude');
    double longitude = await FlutterForegroundTask.getData(key: 'longitude');
    roomLocation = LatLng(latitude, longitude);
  }

  // Called when the task is started.
  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {
    log('Service Started');
    // _streamSubscription = FlLocation.getLocationStream().listen((location) {
    //   log('listener invoked_______________________________');
    //   handleLocationChange(timestamp, sendPort, location, 'Location Listener', false);
    // })
    //   ..onError((e) {
    //     log('Listener Error: ${e.toString()}');
    //   });

    Timer.periodic(const Duration(minutes: 5), (timer) async {
      Location location = await FlLocation.getLocation();
      handleLocationChange(timestamp, sendPort, location, 'Time Listener', true);
    });
  }

  handleLocationChange(DateTime timestamp, SendPort? sendPort, Location location, String type,
      [bool updateNotification = true]) async {
    bool isInRoom = await checkIfInsideRoom(LatLng(location.latitude, location.longitude));
    if (updateNotification) {
      FlutterForegroundTask.updateService(
        notificationTitle: 'User is in office $isInRoom',
        notificationText: '${location.latitude}, ${location.longitude}',
      );
    }
    log('${location.latitude}, ${location.longitude}');

    try {
      final response = await GetConnect().post('https://app-34d7d401-418d-4d77-baa5-9bbe0c7deac1.cleverapps.io/log', {
        "rec_date": DateTime.now().toIso8601String(),
        "details": {
          'user_location': json.encode({
            'latitude': location.latitude.toString(),
            'longitude': location.longitude.toString(),
            'altitude': location.altitude.toString(),
          }),
          'configuration': json.encode({
            'latitude': roomLocation?.latitude.toString(),
            'longitude': roomLocation?.longitude.toString(),
            'radius': roomAreaInMeter.toString(),
          }),
          'isInRoom': isInRoom.toString(),
          "type": type,
          'platform': Platform.operatingSystem,
        },
      });
      log(response.bodyString ?? '');
    } catch (e) {
      log(e.toString());
    }

    // Send data to the main isolate.
    sendPort?.send({
      'latitude': location.latitude,
      'longitude': location.longitude,
      'altitude': location.altitude,
      'isInRoom': isInRoom,
    });
  }

  // Called every [interval] milliseconds in [ForegroundTaskOptions].
  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    // Location location = await FlLocation.getLocation();
    // handleLocationChange(timestamp, sendPort, location, 'onRepeatEvent');
  }

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {
    log('onDestroy invoked');
    try {
      final response = await GetConnect().post('https://app-34d7d401-418d-4d77-baa5-9bbe0c7deac1.cleverapps.io/log', {
        "rec_date": DateTime.now().toIso8601String(),
        "details": {
          'status': 'destroyed',
          'platform': Platform.operatingSystem,
        },
      });
      log(response.bodyString ?? '');
    } catch (e) {
      log(e.toString());
    }
    await _streamSubscription?.cancel();
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed >> $id');
  }

  // Called when the notification itself on the Android platform is pressed.
  //
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }

  Future<bool> checkIfInsideRoom(LatLng userLocation) async {
    const Distance distance = Distance();
    double meter = distance(roomLocation!, userLocation);
    log('distance between (${userLocation.latitude},${userLocation.longitude}) : (${roomLocation!.latitude},${roomLocation!.longitude}) in meter is $meter');
    log('Configuration: ${json.encode(await FlutterForegroundTask.getAllData())}');
    return meter < roomAreaInMeter!;
  }
}
