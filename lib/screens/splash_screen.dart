import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/constants/assets_images.dart';
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
    Future.delayed(Duration(milliseconds: 2500), () {
      Navigator.pushReplacementNamed(context, OnboardingScreen.id);
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
