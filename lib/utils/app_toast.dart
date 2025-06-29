import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast{
  static void showErrorToast(FToast fToast,String message) {
    fToast.showToast(
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.red,
          border: Border.all(color: AppColor.red.shade900, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.cancel_rounded, color: AppColor.white, size: 40),
            SizedBox(width: 16),
            Text(
              message,
              style: AppTextStyles.body1(fontWeight: FontWeight.w600, color: AppColor.white),
            ),
          ],
        ),
      ),
    );
  }

  static void showSuccessToast(FToast fToast, String message) {
    fToast.showToast(
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
      child: Container(
        decoration: BoxDecoration(color: AppColor.green, borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(Icons.check, color: AppColor.white, size: 40),
            SizedBox(width: 16),
            Text(
              message,
              style: AppTextStyles.body1(fontWeight: FontWeight.w600, color: AppColor.white),
            ),
          ],
        ),
      ),
    );
  }
}