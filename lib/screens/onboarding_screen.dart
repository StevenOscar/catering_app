import 'package:carousel_slider/carousel_slider.dart';
import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/constants/assets_images.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  static String id = "/onboarding";
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CarouselSliderController carouselController = CarouselSliderController();
    return Scaffold(
      backgroundColor: AppColor.mainCream,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: CarouselSlider(
                  carouselController: carouselController,
                  items: [
                    Image.asset(AssetsImages.imagesOnboarding1, fit: BoxFit.fitHeight),
                    Image.asset(AssetsImages.imagesOnboarding2, fit: BoxFit.fitHeight),
                    Image.asset(AssetsImages.imagesOnboarding3, fit: BoxFit.fitHeight),
                  ],
                  options: CarouselOptions(
                    height: double.infinity,
                    autoPlay: true,
                    viewportFraction: 1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(AssetsImages.imagesLogo),
                        ),
                        Text("Bekalku"),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Makan siang praktis, nikmat, dan bebas repot!",
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28),
                    ),
                    SizedBox(height: 12),

                    Text(
                      "Rencanakan menu harianmu bersama Bekalku — solusi praktis untuk makan siang di mana saja, setiap hari!",
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: AppColor.mainLightGreen),
                        child: Text("Masuk", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                        child: Text("Daftar", style: TextStyle(color: AppColor.mainLightGreen)),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Dengan masuk atau mendaftar, anda secara bertanggung jawab penuh menyetujui Syarat Ketentuan dan Kebijakan Privasi",
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ],
      ),
    );
  }
}
