import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/constants/app_routes.dart';
import 'package:catering_app/providers/menu_provider.dart';
import 'package:catering_app/providers/user_provider.dart';
import 'package:catering_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuProvider = ChangeNotifierProvider<MenuProvider>((ref) => MenuProvider());
final userProvider = ChangeNotifierProvider<UserProvider>((ref) => UserProvider());

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catering App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: AppColor.mainLightGreen)),
      routes: AppRoutes.routes,
      initialRoute: SplashScreen.id,
    );
  }
}
