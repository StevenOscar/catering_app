import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/screens/add_category_screen.dart';
import 'package:catering_app/screens/add_menu_screen.dart';
import 'package:catering_app/screens/delete_menu_screen.dart';
import 'package:catering_app/screens/update_delete_category_screen.dart';
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<String> titleList = ["Add Menu", "Delete Menu", "Add Category", "Update/Delete Category"];
  List<String> NavigationList = [
    AddMenuScreen.id,
    DeleteMenuScreen.id,
    AddCategoryScreen.id,
    UpdateDeleteCategoryScreen.id,
  ];
  List<IconData> iconList = [
    Icons.add_box_outlined,
    Icons.delete_outline,
    Icons.category_outlined,
    Icons.edit_note_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainCream,
      appBar: AppBar(
        titleSpacing: 24,
        title: Text("Admin Panel", style: AppTextStyles.heading2(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: AppColor.mainCream,
      ),
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 32,
            mainAxisSpacing: 32,
            childAspectRatio: 1,
          ),
          padding: EdgeInsets.symmetric(horizontal: 24),
          itemCount: titleList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, NavigationList[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(60),
                    topLeft: Radius.circular(60),
                  ),
                  color: AppColor.mainOrange,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(iconList[index], color: AppColor.white, size: 75),
                    SizedBox(height: 4),
                    Text(
                      titleList[index],
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body2(
                        fontWeight: FontWeight.w700,
                        color: AppColor.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
