import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/constants/app_routes.dart';
import 'package:catering_app/providers/menu_provider.dart';
import 'package:catering_app/providers/user_provider.dart';
import 'package:catering_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menurovider = NotifierProvider<MenuProvider, void>(() => MenuProvider());
final userrovider = NotifierProvider<UserProvider, UserState>(() => UserProvider());

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catering App',
      locale: const Locale('id', 'ID'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('id', 'ID')],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: AppColor.mainLightGreen)),
      routes: AppRoutes.routes,
      initialRoute: SplashScreen.id,
    );
  }
}
