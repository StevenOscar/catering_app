import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/screens/dashboard_screen.dart';
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static String id = "/main";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPage = 0;
  static List<Widget> screenList = [DashboardScreen(), DashboardScreen(), DashboardScreen()];
  static List<IconData> iconList = [Icons.today, Icons.receipt_long, Icons.delivery_dining_sharp];
  static List<String> labelList = ["Daily", "Order", "Delivery"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainCream,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        height: 70,
        gapLocation: GapLocation.none,
        backgroundColor: AppColor.white,
        tabBuilder: (int index, bool isActive) {
          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Column(
              children: [
                Icon(
                  iconList[index],
                  size: isActive ? 28 : 24,
                  color: isActive ? AppColor.mainOrange : Colors.grey,
                ),
                Text(
                  labelList[index],
                  style: AppTextStyles.body3(
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppColor.mainOrange : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
        activeIndex: currentPage,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 24,
        rightCornerRadius: 24,
        borderColor: AppColor.mainOrange,
        borderWidth: 3,
      ),
      appBar: AppBar(backgroundColor: AppColor.mainCream, toolbarHeight: 4),
      body: screenList[currentPage],
    );
  }
}
