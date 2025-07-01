import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/constants/assets_images.dart';
import 'package:catering_app/helper/shared_pref_helper.dart';
import 'package:catering_app/screens/login_screen.dart';
import 'package:catering_app/screens/main_screen.dart';
import 'package:catering_app/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static String id = "/";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    changePage();
  }

  Future<void> changePage() async {
    Future.delayed(Duration(milliseconds: 2500), () async {
      final token = await SharedPrefHelper.getToken();
      final first = await SharedPrefHelper.getLogin();
      if (token.isNotEmpty) {
        Navigator.pushReplacementNamed(context, MainScreen.id);
      } else if (first) {
        Navigator.pushReplacementNamed(context, LoginScreen.id,   arguments: {'hide_back_button': true},
        );

        await SharedPrefHelper.setLogin(false);
      } else {
        Navigator.pushReplacementNamed(context, OnboardingScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainCream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(48),
              child: Image.asset(AssetsImages.imagesLogoWithText),
            ),
          ],
        ),
      ),
    );
  }
}
