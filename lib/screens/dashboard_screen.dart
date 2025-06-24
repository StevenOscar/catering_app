import 'package:catering_app/constants/app_color.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  static String id = "/dashboard";
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColor.mainCream, body: Column(children: [
      
    ]));
  }
}
