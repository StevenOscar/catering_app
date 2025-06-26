import 'package:catering_app/api/user_api.dart';
import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/constants/assets_images.dart';
import 'package:catering_app/screens/login_screen.dart';
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:catering_app/widgets/elevated_button_widget.dart';
import 'package:catering_app/widgets/text_form_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  static String id = "/register";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool obscureText = false;
  bool _isLoading = false;

  final FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  void register() async {
    setState(() {
      _isLoading = true;
    });
    final res = await UserApi.createUser(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );
    print(res.data);
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      errorList.map((e) {
                        return Text(
                          e,
                          style: AppTextStyles.body1(
                            fontWeight: FontWeight.w600,
                            color: AppColor.white,
                          ),
                          textAlign: TextAlign.start,
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (res.data != null) {
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
                res.message,
                style: AppTextStyles.body1(fontWeight: FontWeight.w600, color: AppColor.white),
              ),
            ],
          ),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } else {
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
                res.message,
                style: AppTextStyles.body1(fontWeight: FontWeight.w600, color: AppColor.white),
              ),
            ],
          ),
        ),
      );
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
                        child: Image.asset(AssetsImages.imagesLogo, width: 120),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Register",
                      style: AppTextStyles.heading3(
                        fontWeight: FontWeight.w900,
                        color: AppColor.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Buat akun baru dengan emailmu dan mulai rasakan kemudahan layanan katering harian kami.",
                      style: AppTextStyles.body2(
                        fontWeight: FontWeight.w400,
                        color: AppColor.black.withValues(alpha: 0.67),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextFormFieldWidget(
                      controller: nameController,
                      hintText: "Nama Lengkap",
                      prefixIcon: Icon(Icons.person, size: 22),
                    ),
                    SizedBox(height: 16),
                    TextFormFieldWidget(
                      controller: emailController,
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email, size: 22),
                      inputFormatters: [],
                    ),
                    SizedBox(height: 16),
                    TextFormFieldWidget(
                      controller: passwordController,
                      hintText: "Password",
                      prefixIcon: Icon(Icons.password, size: 22),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        icon:
                            obscureText
                                ? Icon(Icons.visibility_off, size: 20)
                                : Icon(Icons.visibility, size: 20),
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
                              register();
                            },
                            backgroundColor: AppColor.mainLightGreen,
                            textColor: AppColor.white,
                            text: "Register",
                          ),
                        ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  text: "Sudah mempunyai akun? Silahkan ",
                  style: AppTextStyles.body3(
                    fontWeight: FontWeight.w400,
                    color: AppColor.black.withValues(alpha: 0.67),
                  ),
                  children: [
                    TextSpan(
                      text: "Log in",
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacementNamed(context, LoginScreen.id);
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
