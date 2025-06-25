import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/constants/assets_images.dart';
import 'package:catering_app/screens/register_screen.dart';
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:catering_app/widgets/elevated_button_widget.dart';
import 'package:catering_app/widgets/text_form_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static String id = "/login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: AppColor.mainCream),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColor.mainOrange,
                        radius: 20,
                        child: CircleAvatar(
                          backgroundColor: AppColor.white,
                          radius: 19,
                          child: Icon(Icons.arrow_back, size: 28, color: AppColor.mainOrange),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Hero(
                        tag: "logo",
                        child: Image.asset(AssetsImages.imagesLogo, width: 150),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Log in",
                      style: AppTextStyles.heading3(
                        fontWeight: FontWeight.w900,
                        color: AppColor.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Silakan masuk dengan email yang sudah terdaftar untuk menikmati layanan kami.",
                      style: AppTextStyles.body2(
                        fontWeight: FontWeight.w400,
                        color: AppColor.black.withValues(alpha: 0.67),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormFieldWidget(controller: emailController, hintText: "Email"),
                    SizedBox(height: 16),
                    TextFormFieldWidget(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: obscureText,
                    ),
                    SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButtonWidget(
                        onPressed: () {},
                        backgroundColor: AppColor.mainLightGreen,
                        textColor: AppColor.white,
                        text: "Log In",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  text: "Belum mempunyai akun? Silahkan ",
                  style: AppTextStyles.body3(
                    fontWeight: FontWeight.w400,
                    color: AppColor.black.withValues(alpha: 0.67),
                  ),
                  children: [
                    TextSpan(
                      text: "Daftar",
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, RegisterScreen.id);
                            },
                      style: AppTextStyles.body3(
                        fontWeight: FontWeight.w700,
                        color: AppColor.mainOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
