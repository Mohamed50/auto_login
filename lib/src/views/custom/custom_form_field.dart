import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? label;
  final Widget? icon;
  final InputBorder? border;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged;
  final int? maxLines;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const CustomFormField({Key? key, this.controller, this.hint, this.label, this.validator, this.onSaved, this.icon, this.border, this.maxLines, this.decoration, this.onChanged, this.initialValue, this.keyboardType, this.textInputAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: decoration ?? InputDecoration(
        hintText: hint,
        labelText: label,
        icon: icon,
        border: border,
      ),
    );
  }
}
