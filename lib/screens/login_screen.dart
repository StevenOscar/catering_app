import 'package:catering_app/api/user_api.dart';
import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/constants/assets_images.dart';
import 'package:catering_app/helper/shared_pref_helper.dart';
import 'package:catering_app/screens/main_screen.dart';
import 'package:catering_app/screens/register_screen.dart';
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:catering_app/utils/app_toast.dart';
import 'package:catering_app/widgets/elevated_button_widget.dart';
import 'package:catering_app/widgets/text_form_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  static String id = "/login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  bool _isLoading = false;
  final FToast fToast = FToast();
  bool hideBackButton = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    hideBackButton = args?['hide_back_button'] ?? false;
  }

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  void login() async {
    setState(() {
      _isLoading = true;
    });
    final res = await UserApi.loginUser(
      email: emailController.text,
      password: passwordController.text,
    );
    if (res.errors != null) {
      final errorList = res.errors!.toList();
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    errorList.map((e) {
                      return Text(
                        e,
                        style: AppTextStyles.body1(
                          fontWeight: FontWeight.w600,
                          color: AppColor.white,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      );
    } else if (res.data != null) {
      await SharedPrefHelper.setToken(res.data!.token!);
      await SharedPrefHelper.saveUserData(res.data!.user!);
      AppToast.showSuccessToast(fToast, res.message);
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.id, (route) => false);
    } else {
      AppToast.showErrorToast(fToast, res.message);
    }

    setState(() {
      _isLoading = false;
    });
  }

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
              !hideBackButton
                  ? Padding(
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
                  )
                  : SizedBox(height: 120),
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
                    SizedBox(height: 24),
                    TextFormFieldWidget(
                      controller: emailController,
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email, size: 22, color: AppColor.mainOrange),
                      inputFormatters: [],
                    ),
                    SizedBox(height: 16),
                    TextFormFieldWidget(
                      controller: passwordController,
                      hintText: "Password",
                      maxlines: 1,
                      prefixIcon: Icon(Icons.password, size: 22, color: AppColor.mainOrange),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        icon:
                            obscureText
                                ? Icon(Icons.visibility_off, color: AppColor.mainOrange)
                                : Icon(Icons.visibility, color: AppColor.mainOrange),
                      ),
                      obscureText: obscureText,
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[ ]'))],
                    ),
                    _isLoading ? SizedBox(height: 32) : SizedBox(height: 44),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(
                          width: double.infinity,
                          child: ElevatedButtonWidget(
                            onPressed: () {
                              login();
                            },
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
                              Navigator.pushReplacementNamed(context, RegisterScreen.id);
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
