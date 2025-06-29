import 'package:cached_network_image/cached_network_image.dart';
import 'package:catering_app/api/catering_api.dart';
import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/models/menu_model.dart';
import 'package:catering_app/models/response_model.dart';
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:catering_app/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteMenuScreen extends StatefulWidget {
  static String id = "/delete_menu";
  const DeleteMenuScreen({super.key});

  @override
  State<DeleteMenuScreen> createState() => _DeleteMenuScreenState();
}

class _DeleteMenuScreenState extends State<DeleteMenuScreen> {
  late Future<ResponseModel<List<MenuModel>>> menuFuture;
  TextEditingController searchController = TextEditingController();
  final FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
    menuFuture = CateringApi.getMenu();
  }

  Future<void> delete(int menuId) async {
    final res = await CateringApi.deleteMenu(id: menuId);
    if (res == 200) {
      AppToast.showSuccessToast(fToast, "Menu berhasil dihapus");
      Navigator.pop(context);
    } else {
      AppToast.showErrorToast(fToast, "Menu gagal dihapus");
      Navigator.pop(context);
      return;
    }
    final refreshed = await CateringApi.getMenu();
    if (refreshed.data != null) {
      setState(() {
        menuFuture = Future.value(refreshed);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Menu", style: AppTextStyles.heading3(fontWeight: FontWeight.w700)),
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
            menuFuture = CateringApi.getMenu();
          });
        },
        child: FutureBuilder<ResponseModel<List<MenuModel>>>(
          future: menuFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data!.data != null) {
              final menus = snapshot.data!.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32, left: 20, right: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: menus.length,
                        itemBuilder: (context, index) {
                          final menu = menus[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                title: Text(
                                  menu.title,
                                  style: AppTextStyles.body1(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (menu.category != null)
                                      Text(
                                        menu.category!,
                                        style: AppTextStyles.body2(
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    Text(
                                      "Rp ${menu.price?.toString() ?? '0'}",
                                      style: AppTextStyles.body2(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Tanggal: ${menu.date.day.toString().padLeft(2, '0')}-${menu.date.month.toString().padLeft(2, '0')}-${menu.date.year}",
                                      style: AppTextStyles.body2(fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder:
                                          (_) => AlertDialog(
                                            title: Text("Hapus Menu"),
                                            content: Text(
                                              "Apakah kamu yakin ingin menghapus menu ini?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text("Batal"),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                onPressed: () {
                                                  delete(menu.id!);
                                                },
                                                child: Text("Hapus"),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                ),
                                leading:
                                    menu.imageUrl != null
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: menu.imageUrl!,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            placeholder:
                                                (context, url) => Center(
                                                  child: CircularProgressIndicator(
                                                    color: AppColor.mainOrange,
                                                  ),
                                                ),
                                            errorWidget:
                                                (_, __, ___) => Icon(Icons.broken_image, size: 60),
                                          ),
                                        )
                                        : Icon(Icons.image, size: 60, color: Colors.grey),
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
