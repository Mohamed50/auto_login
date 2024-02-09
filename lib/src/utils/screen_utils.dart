import 'package:flutter/cupertino.dart';

class ScreenUtils {
  static double getScreenHeight(BuildContext context, [double screenPercentage = 1]) {
    return MediaQuery.of(context).size.height * screenPercentage;
  }

  static double getScreenWidth(BuildContext context, [double screenPercentage = 1]) {
    return MediaQuery.of(context).size.width * screenPercentage;
  }
}
