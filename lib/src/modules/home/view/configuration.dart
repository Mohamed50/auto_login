import 'package:auto_login/src/utils/get_utils.dart';
import 'package:auto_login/src/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../views/custom/customs.dart';
import 'package:auto_login/src/modules/home/controller/configuration_view_model.dart';

class ConfigurationSection extends GetView<ConfigurationViewModel> {
  final _formKey = GlobalKey<FormState>();

  ConfigurationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomFormField(
            label: 'Room Area',
            onSaved: controller.onAreaChange,
            validator: InputsValidator.areaValidator,
            maxLines: 1,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 32.0),
          Row(
            children: [
              const CustomText('Room Centered Point'),
              const Spacer(),
              InkWell(
                onTap: () => getLocation(context),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                  child: const Icon(Icons.location_searching_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
          CustomFormField(
            controller: controller.latitudeTextController,
            label: 'Latitude',
            onSaved: controller.onLatitudeChange,
            validator: InputsValidator.latitudeValidator,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            maxLines: 1,
          ),
          CustomFormField(
            controller: controller.longitudeTextController,
            label: 'Longitude',
            onSaved: controller.onLongitudeChange,
            validator: InputsValidator.latitudeValidator,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            maxLines: 1,
          ),
          const SizedBox(height: 24.0),
          CustomButton(
            text: 'Save configuration',
            onPressed: () => _saveConfiguration(context),
          )
        ],
      ),
    );
  }

  void _saveConfiguration(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      actionHandler(context, () async {
        final configuration = Get.find<ConfigurationViewModel>();
        await configuration.saveConfiguration();
      });
    }
  }

  void getLocation(BuildContext context) {
    actionHandler(context, () async {
      await controller.getCurrentLocation();
    });
  }
}
