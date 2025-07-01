import 'dart:convert';
import 'dart:io';

import 'package:catering_app/api/catering_api.dart';
import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/helper/date_formatter.dart';
import 'package:catering_app/models/category_model.dart';
import 'package:catering_app/models/menu_model.dart';
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:catering_app/utils/app_toast.dart';
import 'package:catering_app/widgets/elevated_button_widget.dart';
import 'package:catering_app/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddMenuScreen extends StatefulWidget {
  static String id = "/add_menu";
  const AddMenuScreen({super.key});

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late CategoryModel selectedCategory;
  DateTime dateValue = DateTime.now().add(Duration(days: 1));
  File? selectedImage;
  List<CategoryModel> categories = [];
  final FToast fToast = FToast();
  bool _isLoadingButton = false;
  bool _isLoadingCategory = false;

  @override
  void initState() {
    super.initState();
    fToast.init(context);
    _fetchCategory();
  }

  Future<void> _fetchCategory() async {
    setState(() {
      _isLoadingCategory = true;
    });
    final res = await CateringApi.getCategory();
    if (res.data != null) {
      categories = [...res.data!];
      selectedCategory = categories.first;
    } else {
      AppToast.showErrorToast(fToast, res.message);
      return;
    }
    setState(() {
      _isLoadingCategory = false;
    });
  }

  Future<void> addMenu() async {
    setState(() {
      _isLoadingButton = true;
    });
    final res = await CateringApi.postMenu(
      menu: MenuModel(
        title: titleController.text,
        description: descriptionController.text,
        date: dateValue,
        price: int.tryParse(priceController.text),
        categoryId: selectedCategory.id,
        imageUrl: selectedImage == null ? null : base64Encode(selectedImage!.readAsBytesSync()),
      ),
    );
    if (res.data != null) {
      AppToast.showSuccessToast(fToast, res.message);
      Navigator.pop(context);
    } else if (res.errors != null) {
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
    } else {
      AppToast.showErrorToast(fToast, res.message);
    }
    setState(() {
      _isLoadingButton = false;
    });
  }

  Future<void> pickImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Menu", style: AppTextStyles.heading3(fontWeight: FontWeight.w700)),
        centerTitle: true,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
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
        backgroundColor: AppColor.mainCream,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: AppColor.mainCream),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: selectedImage == null ? Colors.grey.shade400 : null,
                    image:
                        selectedImage == null
                            ? null
                            : DecorationImage(image: FileImage(selectedImage!), fit: BoxFit.cover),
                  ),
                  child:
                      selectedImage == null
                          ? Icon(Icons.add_photo_alternate, size: 60, color: AppColor.white)
                          : SizedBox(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    TextFormFieldWidget(
                      controller: titleController,
                      hintText: "Judul",
                      maxlines: 1,
                      prefixIcon: Icon(Icons.title, size: 22, color: AppColor.mainOrange),
                      inputFormatters: [],
                    ),
                    SizedBox(height: 20),
                    TextFormFieldWidget(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      hintText: "Harga",
                      prefixIcon: Icon(Icons.money, size: 22, color: AppColor.mainOrange),
                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^\d]'))],
                    ),
                    SizedBox(height: 20),
                    TextFormFieldWidget(
                      controller: descriptionController,
                      hintText: "Deskripsi",
                      maxlines: 3,
                      prefixIcon: Icon(Icons.description, size: 22, color: AppColor.mainOrange),
                      inputFormatters: [],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Tanggal Catering",
                            style: AppTextStyles.body1(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            AppDateFormatter.dayDateMonthYear(dateValue),
                            style: AppTextStyles.body2(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButtonWidget(
                          backgroundColor: AppColor.mainLightGreen,
                          textColor: AppColor.white,
                          onPressed: () async {
                            final DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: dateValue,
                              firstDate: DateTime.now().add(Duration(days: 1)),
                              lastDate: DateTime.now().add(Duration(days: 14)),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                dateValue = selectedDate;
                              });
                            }
                          },
                          text: "Pilih Tanggal",
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _isLoadingCategory
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 1.5, color: AppColor.mainOrange),
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton(
                            isExpanded: true,
                            style: AppTextStyles.body2(
                              fontWeight: FontWeight.w500,
                              color: AppColor.black,
                            ),
                            value: selectedCategory,
                            dropdownColor: AppColor.white,
                            icon: Icon(Icons.arrow_drop_down, color: AppColor.black),
                            borderRadius: BorderRadius.circular(10),
                            items: [
                              for (int i = 0; i < categories.length; i++)
                                DropdownMenuItem(
                                  value: categories[i],
                                  child: Text(
                                    categories[i].name,
                                    style: AppTextStyles.body2(
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.black,
                                    ),
                                  ),
                                ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value!;
                              });
                            },
                          ),
                        ),
                    SizedBox(height: 36),
                    _isLoadingButton
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(
                          width: double.infinity,
                          child: ElevatedButtonWidget(
                            onPressed: () {
                              addMenu();
                            },
                            backgroundColor: AppColor.mainLightGreen,
                            textColor: AppColor.white,
                            text: "Add Menu",
                          ),
                        ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
