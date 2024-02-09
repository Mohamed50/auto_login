import 'package:fl_location/fl_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';

class ConfigurationViewModel extends GetxController {
  final TextEditingController latitudeTextController = TextEditingController();
  final TextEditingController longitudeTextController = TextEditingController();

  ConfigurationViewModel(){
    fetchConfiguration();
  }

  final RxDouble _latitude = 0.0.obs;
  double get latitude => _latitude.value;

  final RxDouble _longitude = 0.0.obs;
  double get longitude => _longitude.value;

  final RxDouble _roomArea = 0.0.obs;
  double get roomArea => _roomArea.value;

  final Rx<Map<String, dynamic>> _configuration = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get  configuration => _configuration.value;

  void onLatitudeChange(String? value){
    if(value != null) {
      _latitude.value = double.parse(value);
    }
  }

  void onLongitudeChange(String? value){
    if(value != null) {
      _longitude.value = double.parse(value);
    }
  }

  void onAreaChange(String? value){
    if(value != null) {
      _roomArea.value = double.parse(value);
    }
  }

  Future saveConfiguration() async {
    await FlutterForegroundTask.saveData(key: 'latitude', value: latitude);
    await FlutterForegroundTask.saveData(key: 'longitude', value: longitude);
    await FlutterForegroundTask.saveData(key: 'roomArea', value: roomArea);
    await Future.delayed(const Duration(seconds: 1));
    _configuration.value = await FlutterForegroundTask.getAllData();
  }

  Future fetchConfiguration() async {
    _configuration.value = await FlutterForegroundTask.getAllData();
    await Future.delayed(const Duration(seconds: 1));
  }

  Future getCurrentLocation() async {
    final Location location = await FlLocation.getLocation(accuracy: LocationAccuracy.high);
    latitudeTextController.text = location.latitude.toString();
    longitudeTextController.text = location.longitude.toString();
    _latitude.value = location.latitude;
    _longitude.value = location.longitude;
  }


}
