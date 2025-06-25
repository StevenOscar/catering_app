import 'package:catering_app/screens/dashboard_screen.dart';
import 'package:catering_app/screens/login_screen.dart';
import 'package:catering_app/screens/onboarding_screen.dart';
import 'package:catering_app/screens/register_screen.dart';
import 'package:catering_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext context)> routes = {
    SplashScreen.id: (context) => SplashScreen(),
    DashboardScreen.id: (context) => DashboardScreen(),
    OnboardingScreen.id: (context) => OnboardingScreen(),
    RegisterScreen.id: (context) => RegisterScreen(),
    LoginScreen.id: (context) => LoginScreen(),
  };
}
