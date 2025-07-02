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
  final Widget? prefixIcon;
  final EdgeInsets? contentPadding;
  final Function(String)? onChanged;
  final double? radius;
  final int? maxlines;
  final Widget? suffixIcon;
  final String hintText;

  const TextFormFieldWidget({
    super.key,
    required this.controller,
    this.contentPadding,
    this.maxlines,
    this.obscureText,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onEditingComplete,
    this.prefixIcon,
    this.radius,
    required this.hintText,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: onEditingComplete,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: obscureText ?? false,
      textInputAction: TextInputAction.none,
      onChanged: onChanged,
      maxLines: maxlines,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        isDense: true,
        hintText: hintText,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColor.white,
        hintStyle: TextStyle(fontStyle: FontStyle.italic),
        contentPadding: contentPadding ?? EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 12),
        errorStyle: TextStyle(
          color: Colors.redAccent.shade700,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 10),
          borderSide: BorderSide(color: AppColor.mainOrange, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 10),
          borderSide: BorderSide(color: Colors.redAccent.shade700, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 10),
          borderSide: BorderSide(color: Colors.redAccent.shade700, width: 2.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 10),
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
