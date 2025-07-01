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

class UpdateDeleteCategoryScreen extends StatefulWidget {
  static String id = "/update_delete_category";
  const UpdateDeleteCategoryScreen({super.key});

  @override
  State<UpdateDeleteCategoryScreen> createState() => _UpdateDeleteCategoryScreenState();
}

class _UpdateDeleteCategoryScreenState extends State<UpdateDeleteCategoryScreen> {
  late Future<ResponseModel<List<CategoryModel>>> categoryFuture;
  TextEditingController categoryController = TextEditingController();
  final FToast fToast = FToast();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    categoryFuture = CateringApi.getCategory();
    fToast.init(context);
  }

  Future<void> editCategory(String category, int categoryId) async {
    setState(() {
      _isLoading = true;
    });
    final res = await CateringApi.updateCategory(name: category, categoryId: categoryId);
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
    setState(() {
      _isLoading = false;
    });
  }

  void updateCategory(CategoryModel category) {
    final categoryController = TextEditingController(text: category.name);
    bool isLoading = false;
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
                      isLoading
                          ? CircularProgressIndicator()
                          : SizedBox(
                            width: double.infinity,
                            child: ElevatedButtonWidget(
                              text: "Edit Kategori",
                              backgroundColor: AppColor.mainLightGreen,
                              textColor: AppColor.white,
                              onPressed:
                                  categoryController.text.isEmpty
                                      ? null
                                      : () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        editCategory(categoryController.text, category.id);
                                        setState(() {
                                          isLoading = false;
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

  Future<void> delete(int categoryId) async {
    final res = await CateringApi.deleteCategory(categoryId: categoryId);
    if (res == 200) {
      AppToast.showSuccessToast(fToast, "Kategori berhasil dihapus");
      Navigator.pop(context);
    } else {
      AppToast.showErrorToast(fToast, "Kategori gagal dihapus");
      Navigator.pop(context);
      return;
    }
    final refreshed = await CateringApi.getCategory();
    if (refreshed.data != null) {
      setState(() {
        categoryFuture = Future.value(refreshed);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit/Delete Category",
          style: AppTextStyles.heading3(fontWeight: FontWeight.w700),
        ),
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
                  padding: const EdgeInsets.only(bottom: 32, left: 20, right: 20, top: 20),
                  child: Column(
                    children: [
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
                                  "Category ID: ${category.id}",
                                  style: AppTextStyles.body2(fontWeight: FontWeight.w400),
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          updateCategory(category);
                                        },
                                        child: Icon(Icons.edit, color: AppColor.blue),
                                      ),
                                      SizedBox(width: 16),
                                      GestureDetector(
                                        onTap: () async {
                                          await showDialog(
                                            context: context,
                                            builder:
                                                (_) => AlertDialog(
                                                  backgroundColor: AppColor.white,
                                                  title: Text(
                                                    "Hapus Kategori",
                                                    style: AppTextStyles.heading3(
                                                      fontWeight: FontWeight.w800,
                                                      color: AppColor.mainOrange,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "Apakah kamu yakin ingin menghapus kategori ini?",
                                                    style: AppTextStyles.body2(
                                                      fontWeight: FontWeight.w400,
                                                      color: AppColor.black,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text(
                                                        "Batal",
                                                        style: AppTextStyles.body3(
                                                          fontWeight: FontWeight.w600,
                                                          color: AppColor.black,
                                                        ),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: AppColor.red,
                                                      ),
                                                      onPressed: () {
                                                        delete(category.id);
                                                      },
                                                      child: Text(
                                                        "Hapus",
                                                        style: AppTextStyles.body3(
                                                          fontWeight: FontWeight.w600,
                                                          color: AppColor.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        },
                                        child: Icon(Icons.delete, color: AppColor.red),
                                      ),
                                    ],
                                  ),
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
                  child: Text(
                    "Tidak ada menu tersedia",
                    style: AppTextStyles.body2(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
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
