import 'dart:math';

import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/models/menu_model.dart';
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  static String id = "/dashboard";
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 7;
  DateTime today = DateTime.now();
  List<String> categoryList = [
    "Makanan Fast Food",
    "Makanan Asia",
    "Makanan Italia",
    "Makanan Dessert",
  ];
  List<MenuModel> menuList = [
    MenuModel(
      id: 1,
      title: "Nasi Goreng",
      description: "Nasi goreng kampung dengan telur dan kerupuk",
      date: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MenuModel(
      id: 2,
      title: "Ayam Bakar asdas dasd asd ad ad ",
      description: "Ayam bakar bumbu khas dengan sambal dan lalapan",
      date: DateTime.now().add(Duration(days: 1)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MenuModel(
      id: 3,
      title: "Soto Ayam",
      description: "Soto ayam bening dengan nasi dan perkedel",
      date: DateTime.now().add(Duration(days: 2)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MenuModel(
      id: 4,
      title: "Rendang Daging",
      description: "Rendang daging sapi dengan nasi dan sayur singkong",
      date: DateTime.now().add(Duration(days: 3)),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MenuModel(
      id: 5,
      title: "Pecel Lele",
      description: "Lele goreng dengan sambal, nasi, dan lalapan",
      date: DateTime.now().add(Duration(days: 4)),
    ),
    MenuModel(
      id: 6,
      title: "Capcay Goreng",
      description: "Capcay goreng lengkap dengan bakso dan udang",
      date: DateTime.now().add(Duration(days: 5)),
      price: 10000,
      imageUrl: null,
      imagePath: null
    ),
  ];
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainCream,
      appBar: AppBar(backgroundColor: AppColor.mainCream, toolbarHeight: 4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.location_on, size: 16, color: Colors.green),
                      SizedBox(width: 4),
                      Text("Google Building 43"),
                      Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                  Icon(Icons.search),
                ],
              ),
            ),
            const SizedBox(height: 12),
            EasyTheme(
              data: EasyTheme.of(context).copyWith(
                dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColor.mainOrange;
                  } else if (states.contains(WidgetState.disabled)) {
                    return Colors.grey.shade100;
                  }
                  return Colors.white;
                }),
              ),
              child: EasyDateTimeLinePicker(
                locale: Locale("id"),
                headerOptions: HeaderOptions(headerType: HeaderType.none),
                itemExtent: 80,
                firstDate: today.subtract(Duration(days: 1)),
                disableStrategy: DisableStrategy.before(today.add(Duration(days: 1))),
                lastDate: today.add(Duration(days: 14)),
                focusedDate: _selectedDate,
                onDateChange: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ListView.builder(
              itemCount: categoryList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        categoryList[index],
                        style: AppTextStyles.heading3(fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: menuList.length,
                        itemBuilder: (context, index) {
                          final random = Random();
                          int randomNumber = random.nextInt(3);
                          return Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: SizedBox(
                              width: 160,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: AppColor.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        child: Image.asset(
                                          "assets/images/onboarding_${randomNumber + 1}.jpg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        menuList[index].title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      menuList[index].price.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
