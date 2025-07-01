import 'package:cached_network_image/cached_network_image.dart';
import 'package:catering_app/api/catering_api.dart';
import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/helper/date_formatter.dart';
import 'package:catering_app/helper/money_formatter.dart';
import 'package:catering_app/helper/shared_pref_helper.dart';
import 'package:catering_app/models/menu_model.dart';
import 'package:catering_app/models/response_model.dart';
import 'package:catering_app/models/user_model.dart';
import 'package:catering_app/screens/onboarding_screen.dart';
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:catering_app/utils/app_toast.dart';
import 'package:catering_app/widgets/elevated_button_widget.dart';
import 'package:catering_app/widgets/text_form_field_widget.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DashboardScreen extends StatefulWidget {
  static String id = "/dashboard";
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<ResponseModel<List<MenuModel>>> menuFuture;
  late User userData;
  TextEditingController searchController = TextEditingController();
  final FToast fToast = FToast();
  DateTime today = DateTime.now();
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));

  @override
  void initState() {
    super.initState();
    fToast.init(context);
    _initializeUser();
    menuFuture = CateringApi.getMenu();
  }

  Future<void> _initializeUser() async {
    final localUser = await SharedPrefHelper.getUserData();

    setState(() {
      userData = User(
        name: localUser["name"],
        email: localUser["email"],
        createdAt: DateTime.parse(localUser["created_at"]),
      );
    });
  }

  Map<String, List<MenuModel>> _filterMenusByDate(List<MenuModel> menus) {
    final Map<String, List<MenuModel>> categorized = {};

    for (final menu in menus) {
      final menuDate = DateTime(menu.date.year, menu.date.month, menu.date.day);
      if (menuDate == DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)) {
        final category = menu.category ?? "No Category";
        if (!categorized.containsKey(category)) {
          categorized[category] = [];
        }
        if (menu.title.toLowerCase().contains(searchController.text.toLowerCase())) {
          categorized[category]!.add(menu);
        }
      }
    }
    return categorized;
  }

  Future<void> viewDetail(MenuModel menu) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.95,
            decoration: BoxDecoration(
              color: AppColor.mainCream,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      child: CachedNetworkImage(
                        height: MediaQuery.of(context).size.height * 0.45,
                        imageUrl: menu.imageUrl ?? "",
                        errorWidget:
                            (context, url, error) =>
                                Center(child: Icon(Icons.image_not_supported, size: 50)),
                        placeholder:
                            (context, url) => Center(
                              child: CircularProgressIndicator(color: AppColor.mainOrange),
                            ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(color: AppColor.mainOrange.withValues(alpha: 0.9)),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, color: AppColor.white),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Makan Siang • ${AppDateFormatter.dayDateMonthYear(menu.date)}",
                                style: AppTextStyles.body3(
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.white,
                                ),
                              ),
                              Text(
                                "Perkiraan pengiriman tiba pukul 09:00 - 12.30",
                                style: AppTextStyles.body3(
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menu.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.heading3(
                              fontWeight: FontWeight.w800,
                              height: 1.3,
                              color: AppColor.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            MoneyFormatter.toIdr(menu.price!),
                            style: AppTextStyles.body1(
                              fontWeight: FontWeight.w500,
                              color: AppColor.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Divider(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.17,
                            child: ListView(
                              children: [
                                Text(
                                  "Description",
                                  style: AppTextStyles.body1(
                                    fontWeight: FontWeight.w900,
                                    color: AppColor.mainOrange,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  menu.description ?? "No description",
                                  style: AppTextStyles.body2(
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, bottom: 48, right: 24),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButtonWidget(
                          onPressed: () {
                            inputAddress(menu: menu);
                          },
                          text: "Input Alamat Pemesanan",
                          backgroundColor: AppColor.mainLightGreen,
                          textColor: AppColor.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 24,
                  left: 20,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.close, size: 35, color: AppColor.mainOrange),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void inputAddress({required MenuModel menu}) {
    final addressController = TextEditingController();
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
                        "Alamat Pemesanan",
                        style: AppTextStyles.heading3(
                          fontWeight: FontWeight.w800,
                          color: AppColor.mainOrange,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormFieldWidget(
                        controller: addressController,
                        inputFormatters: [],
                        hintText: "Masukkan alamat kamu disini",
                        radius: 20,
                        onChanged: (p0) => setState(() {}),
                      ),
                      SizedBox(height: 28),
                      isLoading
                          ? CircularProgressIndicator()
                          : SizedBox(
                            width: double.infinity,
                            child: ElevatedButtonWidget(
                              text: "Pesan Sekarang",
                              backgroundColor: AppColor.mainLightGreen,
                              textColor: AppColor.white,
                              onPressed:
                                  addressController.text.isEmpty
                                      ? null
                                      : () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        order(
                                          menuId: menu.id!,
                                          deliveryAddress: addressController.text,
                                        );
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

  Future<void> order({required int menuId, required String deliveryAddress}) async {
    final res = await CateringApi.postOrder(menuId: menuId, deliveryAddress: deliveryAddress);
    if (res.data != null) {
      AppToast.showSuccessToast(fToast, res.message);
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      AppToast.showErrorToast(fToast, res.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainCream,
      appBar: AppBar(backgroundColor: AppColor.mainCream, toolbarHeight: 4),
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
              final categorizedMenus = _filterMenusByDate(menus);
              return ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 28, color: AppColor.mainLightGreen),
                            const SizedBox(width: 4),
                            Text(
                              "PPKD Jakarta Pusat",
                              style: AppTextStyles.body2(fontWeight: FontWeight.w800),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    backgroundColor: AppColor.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const CircleAvatar(
                                              radius: 40,
                                              backgroundColor: AppColor.mainOrange,
                                              child: Icon(
                                                Icons.person,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              userData.name ?? '-',
                                              style: AppTextStyles.body1(
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.mainOrange,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              userData.email ?? '-',
                                              style: AppTextStyles.body2(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[700],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Divider(color: Colors.grey[300]),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Tanggal Pendaftaran",
                                          style: AppTextStyles.body2(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          AppDateFormatter.dateMonthYear(userData.createdAt!),
                                          style: AppTextStyles.body2(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            icon: Icon(
                                              Icons.logout,
                                              size: 18,
                                              color: AppColor.white,
                                            ),
                                            label: Text(
                                              "Log out",
                                              style: AppTextStyles.body2(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColor.red,
                                              foregroundColor: AppColor.white,
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () async {
                                              await SharedPrefHelper.deleteLogin();
                                              await SharedPrefHelper.deleteToken();
                                              await SharedPrefHelper.deleteUserData();
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                OnboardingScreen.id,
                                                (route) => false,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColor.mainOrange),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: Row(
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 70),
                                  child: Text(
                                    userData.name ?? '-',
                                    style: AppTextStyles.body3(
                                      fontWeight: FontWeight.w800,
                                      color: AppColor.mainOrange,
                                    ),
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColor.mainOrange,
                                  child: Icon(Icons.person, color: AppColor.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        searchController.clear();
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 36),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextFormFieldWidget(
                      controller: searchController,
                      radius: 25,
                      contentPadding: EdgeInsets.only(left: 28, right: 28, top: 16, bottom: 12),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(Icons.search, size: 26, color: AppColor.mainOrange),
                      ),
                      hintText: "Cari menu kesukaanmu disini!",
                      onChanged: (p0) {
                        setState(() {
                          _filterMenusByDate(menus);
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  if (categorizedMenus.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Center(
                        child: Text(
                          "Tidak ada menu apapun pada\n${AppDateFormatter.dateMonthYear(_selectedDate)}",
                          style: AppTextStyles.body2(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else if (categorizedMenus.values.every((list) => list.isEmpty))
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Center(
                        child: Text(
                          "Menu tidak ditemukan",
                          style: AppTextStyles.body2(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    ...categorizedMenus.entries.map((entry) {
                      final category = entry.key;
                      final menuList = entry.value;
                      return menuList.isEmpty
                          ? SizedBox()
                          : Padding(
                            padding: EdgeInsets.only(bottom: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 28),
                                  child: Text(
                                    category,
                                    style: AppTextStyles.heading3(fontWeight: FontWeight.w900),
                                  ),
                                ),
                                SizedBox(height: 8),
                                SizedBox(
                                  height: 260,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: menuList.length,
                                    physics: BouncingScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    itemBuilder: (context, index) {
                                      final menu = menuList[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: GestureDetector(
                                          onTap: () => viewDetail(menu),
                                          child: SizedBox(
                                            width: 180,
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              color: AppColor.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.vertical(
                                                      top: Radius.circular(10),
                                                    ),
                                                    child: Center(
                                                      child: CachedNetworkImage(
                                                        height: 155,
                                                        imageUrl: menu.imageUrl ?? "",
                                                        errorWidget:
                                                            (context, url, error) => Center(
                                                              child: Container(
                                                                height: double.infinity,
                                                                width: double.infinity,
                                                                color: Colors.grey.shade400,
                                                                child: Icon(
                                                                  Icons.image_not_supported,
                                                                  size: 50,
                                                                ),
                                                              ),
                                                            ),
                                                        placeholder:
                                                            (context, url) => Center(
                                                              child: CircularProgressIndicator(
                                                                color: AppColor.mainOrange,
                                                              ),
                                                            ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      left: 12,
                                                      top: 8,
                                                      right: 12,
                                                      bottom: 12,
                                                    ),
                                                    child: Text(
                                                      menu.title,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: AppTextStyles.body2(
                                                        fontWeight: FontWeight.w600,
                                                        height: 1.3,
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                      left: 12,
                                                      right: 12,
                                                      bottom: 12,
                                                    ),
                                                    child: Text(
                                                      MoneyFormatter.toIdr(menu.price!),
                                                      style: AppTextStyles.body2(
                                                        fontWeight: FontWeight.w800,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                    }),
                  SizedBox(height: 20),
                ],
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
