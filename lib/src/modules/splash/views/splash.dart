import 'package:auto_login/src/utils/screen_utils.dart';
import 'package:auto_login/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../config/config.dart';
import '../../../views/custom/customs.dart';
import '../splash.dart';

class SplashPage extends StatefulWidget {
  final String nextRouteName;
  final int delayInSeconds;

  const SplashPage({Key? key, this.nextRouteName = RouteManager.homeRoute, this.delayInSeconds = 1}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                logoPath,
                width: ScreenUtils.getScreenHeight(context, 0.2),
                height: ScreenUtils.getScreenHeight(context, 0.2),
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(height: 12.0),
            GetX<SplashViewModel>(builder: (controller) => StateWidget(state: controller.state)),
            GetX<SplashViewModel>(
              builder: (controller) => CustomVisible(
                show: controller.state != ConfigurationState.checking && controller.state != ConfigurationState.completed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => _tryAgain(context),
                      child: CustomText(
                        'Try Again',
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _skip(context),
                      child: CustomText(
                        'Skip',
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _init() {
    SplashActions.instance.initSplash(widget.nextRouteName, widget.delayInSeconds);
  }

  _tryAgain(BuildContext context) {
    SplashActions.instance.initSplash(RouteManager.homeRoute, 1);
  }

  _skip(BuildContext context) {
    SplashActions.instance.skip(RouteManager.homeRoute, 1);
  }
}

class StateWidget extends StatelessWidget {
  final ConfigurationState state;

  const StateWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case ConfigurationState.checking:
        return const CustomText('Wait a second we are checking everything');
      case ConfigurationState.bluetoothNotGranted:
        return const CustomText('Bluetooth permission not granted, please grant the permission');
      case ConfigurationState.bluetoothNotOpened:
        return const CustomText('Bluetooth not enabled, please enable bluetooth');
      case ConfigurationState.locationNotGranted:
        return const CustomText('Location permission not granted, please grant the permission');
      case ConfigurationState.locationNotOpened:
        return const CustomText('Location not enabled, please enable location');
      case ConfigurationState.completed:
        return const CustomText('all good');
    }
  }
}
