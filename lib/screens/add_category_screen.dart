import 'package:catering_app/api/catering_api.dart';
import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/models/category_model.dart';
import 'package:catering_app/models/response_model.dart';
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:catering_app/utils/app_toast.dart';
import 'package:catering_app/widgets/elevated_button_widget.dart';
import 'package:catering_app/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCategoryScreen extends StatefulWidget {
  static String id = "/add_category";

  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  late Future<ResponseModel<List<CategoryModel>>> categoryFuture;
  TextEditingController categoryController = TextEditingController();
  final FToast fToast = FToast();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fToast.init(context);
    categoryFuture = CateringApi.getCategory();
  }

  Future<void> addCategory(String category) async {
    final res = await CateringApi.postCategory(name: category);
    if (res.data != null) {
      AppToast.showSuccessToast(fToast, res.message);
      Navigator.pop(context);
      final refreshed = await CateringApi.getCategory();
      if (refreshed.data != null) {
        setState(() {
          categoryFuture = Future.value(refreshed);
        });
      }
    } else {
      AppToast.showErrorToast(fToast, res.message);
    }
  }

  void inputCategory() {
    final categoryController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                decoration: BoxDecoration(color: AppColor.mainCream),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 64),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Masukkan kategori",
                        style: AppTextStyles.heading3(
                          fontWeight: FontWeight.w800,
                          color: AppColor.mainOrange,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormFieldWidget(
                        controller: categoryController,
                        inputFormatters: [],
                        hintText: "Kategori",
                        radius: 20,
                        onChanged: (p0) => setState(() {}),
                      ),
                      SizedBox(height: 28),
                      _isLoading
                          ? CircularProgressIndicator()
                          : SizedBox(
                            width: double.infinity,
                            child: ElevatedButtonWidget(
                              text: "Tambah Kategori",
                              backgroundColor: AppColor.mainLightGreen,
                              textColor: AppColor.white,
                              onPressed:
                                  categoryController.text.isEmpty
                                      ? null
                                      : () {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        addCategory(categoryController.text);
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      },
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category", style: AppTextStyles.heading3(fontWeight: FontWeight.w700)),
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
      backgroundColor: AppColor.mainCream,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            categoryFuture = CateringApi.getCategory();
          });
        },
        child: FutureBuilder<ResponseModel<List<CategoryModel>>>(
          future: categoryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data!.data != null) {
              final categories = snapshot.data!.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32, left: 20, right: 20, top: 40),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButtonWidget(
                            backgroundColor: AppColor.mainLightGreen,
                            textColor: AppColor.white,
                            onPressed: () async {
                              inputCategory();
                            },
                            text: "Tambah Kategori",
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Kategori yang sudah dibuat",
                        style: AppTextStyles.heading3(
                          fontWeight: FontWeight.w800,
                          color: AppColor.mainOrange,
                        ),
                      ),
                      SizedBox(height: 20),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Card(
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: AppColor.mainOrange, width: 1),
                              ),
                              elevation: 4,
                              child: ListTile(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: AppColor.mainOrange, width: 1),
                                ),
                                tileColor: AppColor.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                title: Text(
                                  category.name,
                                  style: AppTextStyles.body1(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "ID Kategori: ${category.id}",
                                  style: AppTextStyles.body2(fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
              AppToast.showErrorToast(fToast, snapshot.data?.message ?? "Error tidak diketahui");
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category, size: 80),
                      SizedBox(height: 12),
                      Text(
                        "Tidak ada Kategori tersedia",
                        style: AppTextStyles.body2(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
