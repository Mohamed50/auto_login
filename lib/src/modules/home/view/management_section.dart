import 'package:auto_login/src/modules/foreground_service/controller/foreground_view_model.dart';
import 'package:auto_login/src/modules/home/controller/configuration_view_model.dart';
import 'package:auto_login/src/utils/get_utils.dart';
import 'package:auto_login/src/views/custom/customs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceManagementSection extends GetView<ForegroundViewModel> {
  const ServiceManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool isServiceRunning = controller.isServiceRunning;
        return Column(
          children: [
            CustomText('Service is${isServiceRunning ? ' ' : ' Not '}Running'),
            const SizedBox(height: 12.0),
            !isServiceRunning
                ? CustomButton(
                    text: 'Start service',
                    onPressed: () => start(context),
                  )
                : CustomButton(
                    text: 'Stop service',
                    onPressed: controller.stopForegroundTask,
                  ),
            Obx(() => CustomText('Messages: ${controller.messages}')),
            GetX<ConfigurationViewModel>(builder: (controller) => CustomText('Configuration: ${controller.configuration}'))
          ],
        );
      },
    );
  }

  void start(BuildContext context) {
    actionHandler(context, () async {
      await controller.startForegroundTask();
    });
  }
}
