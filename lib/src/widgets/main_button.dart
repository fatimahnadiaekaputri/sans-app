import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton(
      {super.key,
      this.buttonText,
      this.onTap,
      this.buttonColor,
      this.textColor,
      this.height,
      this.width,
      this.fontSize,
      this.fontWeight});
  final String? buttonText;
  final VoidCallback? onTap;
  final Color? buttonColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50,
        width: width ?? 125,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: buttonColor!,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            buttonText!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize ?? 15,
              fontWeight: fontWeight ?? FontWeight.w400,
              color: textColor!,
            ),
          ),
        ),
      ),
    );
  }
}
