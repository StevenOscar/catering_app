// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final void Function() onPressed;

  const ElevatedButtonWidget({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
        backgroundColor: backgroundColor,
      ),
      child: Text(text, style: AppTextStyles.body1(fontWeight: FontWeight.w800, color: textColor)),
    );
  }
}
