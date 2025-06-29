import 'package:carousel_slider/carousel_slider.dart';
import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/constants/assets_images.dart';
import 'package:catering_app/helper/shared_pref_helper.dart';
import 'package:catering_app/screens/login_screen.dart';
import 'package:catering_app/screens/register_screen.dart';
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:catering_app/widgets/elevated_button_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  static String id = "/onboarding";
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final CarouselSliderController carouselController = CarouselSliderController();
  List<String> imgList = [
    AssetsImages.imagesOnboarding1,
    AssetsImages.imagesOnboarding2,
    AssetsImages.imagesOnboarding3,
  ];
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainCream,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(40, 18)),
                  child: CarouselSlider(
                    carouselController: carouselController,
                    items: imgList.map((e) => Image.asset(e, fit: BoxFit.fitHeight)).toList(),
                    options: CarouselOptions(
                      height: double.infinity,
                      autoPlay: true,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          current = index;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    imgList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => carouselController.animateToPage(entry.key),
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColor.mainOrange)
                                .withValues(alpha: current == entry.key ? 0.9 : 0.4),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: "logo",
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.asset(AssetsImages.imagesLogo),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "BekalKu",
                          style: AppTextStyles.heading3(
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                            color: AppColor.mainOrange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Makan siang praktis, nikmat, dan bebas repot!",
                      style: AppTextStyles.heading2(fontWeight: FontWeight.w800, height: 1.3),
                    ),
                    SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: "Rencanakan menu harianmu bersama ",
                        style: AppTextStyles.body2(
                          fontWeight: FontWeight.w500,
                          color: AppColor.black.withValues(alpha: 0.67),
                        ),
                        children: [
                          TextSpan(
                            text: "Bekalku ",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w700,
                              color: AppColor.black,
                            ),
                          ),
                          TextSpan(
                            text: "solusi praktis untuk makan siang di mana saja, setiap hari!",
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w500,
                              color: AppColor.black.withValues(alpha: 0.67),
                            ),
                          ),
                        ],
                      ),
                      style: AppTextStyles.body2(fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButtonWidget(
                        text: "Masuk",
                        backgroundColor: AppColor.mainLightGreen,
                        textColor: AppColor.white,
                        onPressed: () {
                          SharedPrefHelper.setLogin(true);
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButtonWidget(
                        text: "Register",
                        backgroundColor: AppColor.white,
                        textColor: AppColor.mainLightGreen,
                        onPressed: () {
                          SharedPrefHelper.setLogin(true);
                          Navigator.pushNamed(context, RegisterScreen.id);
                        },
                      ),
                    ),
                    SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text:
                              "Dengan masuk atau mendaftar, Anda menyetujui dan bertanggung jawab atas kepatuhan pada ",
                          style: AppTextStyles.body4(fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                              text: "Syarat Ketentuan ",
                              style: AppTextStyles.body4(fontWeight: FontWeight.w900),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            TextSpan(
                              text: "serta ",
                              style: AppTextStyles.body4(fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text: "Kebijakan Privasi.",
                              style: AppTextStyles.body4(fontWeight: FontWeight.w900),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 44),
            ],
          ),
        ],
      ),
    );
  }
}
