import 'package:auto_login/src/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final double width;
  final Color textColor;
  final Color backgroundColor;
  final double fontSize;

  const CustomButton({Key? key, required this.text, this.onPressed, this.width = double.infinity, this.icon, this.textColor = Colors.white, this.fontSize = 16.0, this.backgroundColor = primaryColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          width: width,
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: icon != null ? 24.0 : 0,
              ),
              CustomText(
                text,
                textStyle: GoogleFonts.montserrat(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              icon ?? Container(),
            ],
          )),
    );
  }
}
