// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:catering_app/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onEditingComplete;
  final Icon? prefixIcon;
  final String hintText;

  const TextFormFieldWidget({
    super.key,
    required this.controller,
    this.obscureText,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onEditingComplete,
    this.prefixIcon,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: onEditingComplete,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        isDense: true,
        hintText: hintText,
        filled: true,
        fillColor: AppColor.white,
        hintStyle: TextStyle(fontStyle: FontStyle.italic),
        contentPadding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 12),
        errorStyle: TextStyle(
          color: Colors.redAccent.shade700,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.black, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.redAccent.shade700, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.redAccent.shade700, width: 2.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.mainOrange, width: 2.5),
        ),
      ),
      validator: validator,
      inputFormatters:
          inputFormatters ??
          [
            FilteringTextInputFormatter.deny(RegExp(r'[!@#$%^&*(),.?":{}|<>]]')),
            FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
          ],
      keyboardType: keyboardType,
    );
  }
}
