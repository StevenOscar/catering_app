import 'package:catering_app/api/catering_api.dart';
import 'package:catering_app/constants/app_color.dart';
import 'package:catering_app/helper/date_formatter.dart';
import 'package:catering_app/helper/money_formatter.dart';
import 'package:catering_app/models/order_model.dart';
import 'package:catering_app/models/response_model.dart';
import 'package:catering_app/styles/app_text_styles.dart';
import 'package:catering_app/utils/app_toast.dart';
import 'package:catering_app/widgets/elevated_button_widget.dart';
import 'package:catering_app/widgets/text_form_field_widget.dart';
import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<ResponseModel<List<OrderModel>>> orderFuture;
  final FToast fToast = FToast();
  String status = "all";

  @override
  void initState() {
    fToast.init(context);
    orderFuture = CateringApi.getOrder();
    super.initState();
  }

  List<OrderModel> _filterOrderByStatus(List<OrderModel> orders) {
    List<OrderModel> categorized = [];

    if (status == "all") {
      categorized = [...orders];
      categorized.sort((a, b) {
        return a.menu!.date.compareTo(b.menu!.date);
      });
      return categorized;
    }

    for (final order in orders) {
      if (order.status == status) {
        categorized.add(order);
      }
    }
    categorized.sort((a, b) {
      return b.menu!.date.compareTo(a.menu!.date);
    });

    return categorized;
  }

  Color _statusColor(String status) {
    return status == "all"
        ? AppColor.black
        : status == "pending"
        ? AppColor.mainOrange
        : status == "on_delivery"
        ? AppColor.blue
        : AppColor.green;
  }

  void editOrder({required OrderModel order}) {
    String status = order.status!;
    final TextEditingController addressController = TextEditingController(
      text: order.deliveryAddress,
    );
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
                decoration: BoxDecoration(
                  color: AppColor.mainCream,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 64),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: AppColor.mainOrange,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          children: [
                            Icon(Icons.fastfood_outlined, color: AppColor.white),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                order.menu!.title,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.body2(
                                  fontWeight: FontWeight.w800,
                                  color: AppColor.white,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text("Hapus Pesanan"),
                                        content: Text(
                                          "Apakah anda yakin ingin menghapus pesanan ini?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Batal"),
                                          ),
                                          SizedBox(width: 12),
                                          TextButton(
                                            onPressed: () {
                                              delete(order.id);
                                            },
                                            child: Text("Ya"),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              icon: Icon(Icons.delete, color: AppColor.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                        child: Column(
                          children: [
                            Text(
                              "Status Pengiriman",
                              style: AppTextStyles.heading3(
                                fontWeight: FontWeight.w800,
                                color: AppColor.mainOrange,
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(width: 1, color: AppColor.black),
                              ),
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: DropdownButton(
                                isExpanded: true,
                                style: AppTextStyles.body2(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.black,
                                ),
                                dropdownColor: AppColor.white,
                                icon: Icon(Icons.arrow_drop_down, color: AppColor.black),
                                borderRadius: BorderRadius.circular(10),
                                value: status,
                                items: [
                                  DropdownMenuItem(
                                    value: "pending",
                                    child: Text(
                                      "Pending",
                                      style: AppTextStyles.body2(
                                        fontWeight: FontWeight.w800,
                                        color: AppColor.mainOrange,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "on_delivery",
                                    child: Text(
                                      "On Delivery",
                                      style: AppTextStyles.body2(
                                        fontWeight: FontWeight.w800,
                                        color: AppColor.blue,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "delivered",
                                    child: Text(
                                      "Delivered",
                                      style: AppTextStyles.body2(
                                        fontWeight: FontWeight.w800,
                                        color: AppColor.green,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  status = value!;
                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(height: 16),
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
                            SizedBox(height: 52),
                            isLoading
                                ? CircularProgressIndicator()
                                : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButtonWidget(
                                    text: "Perbarui",
                                    backgroundColor: AppColor.mainLightGreen,
                                    textColor: AppColor.white,
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await update(
                                        address: addressController.text,
                                        status: status,
                                        order: order,
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

  Future<void> update({
    required OrderModel order,
    required String status,
    required String address,
  }) async {
    bool updated = false;

    if (order.status != status) {
      final res = await CateringApi.updateDeliveryStatus(status: status, orderId: order.id);
      if (res.data != null) {
        AppToast.showSuccessToast(fToast, res.message);
        updated = true;
      } else {
        AppToast.showErrorToast(fToast, res.message);
        return;
      }
    }

    if (order.deliveryAddress != address) {
      print(order.id);
      final res = await CateringApi.updateDeliveryAddress(
        deliveryAddress: address,
        orderId: order.id,
      );
      if (res.data != null) {
        AppToast.showSuccessToast(fToast, res.message);
        updated = true;
      } else {
        AppToast.showErrorToast(fToast, res.message);
        return;
      }
    }

    if (updated) {
      final refreshed = await CateringApi.getOrder();
      if (refreshed.data != null) {
        setState(() {
          orderFuture = Future.value(refreshed);
        });
      }
    }
    Navigator.pop(context);
  }

  Future<void> delete(int orderId) async {
    await CateringApi.deleteOrder(orderId: orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 30,
        title: Text("Pemesanan", style: AppTextStyles.heading3(fontWeight: FontWeight.w700)),
        backgroundColor: AppColor.mainCream,
      ),
      backgroundColor: AppColor.mainCream,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            orderFuture = CateringApi.getOrder();
          });
        },
        child: FutureBuilder(
          future: orderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.data != null) {
              final orderList = snapshot.data!.data;
              final categorizedOrder = _filterOrderByStatus(orderList!);
              Color currColor = _statusColor(status);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                child: ListView(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 2, color: currColor),
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton(
                        isExpanded: true,
                        style: AppTextStyles.body2(
                          fontWeight: FontWeight.w500,
                          color: AppColor.black,
                        ),
                        dropdownColor: AppColor.white,
                        icon: Icon(Icons.arrow_drop_down, color: currColor),
                        borderRadius: BorderRadius.circular(10),
                        value: status,
                        items: [
                          DropdownMenuItem(
                            value: "all",
                            child: Text(
                              "All",
                              style: AppTextStyles.body2(
                                fontWeight: FontWeight.w800,
                                color: AppColor.black,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "pending",
                            child: Text(
                              "Pending",
                              style: AppTextStyles.body2(
                                fontWeight: FontWeight.w800,
                                color: AppColor.mainOrange,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "on_delivery",
                            child: Text(
                              "On Delivery",
                              style: AppTextStyles.body2(
                                fontWeight: FontWeight.w800,
                                color: AppColor.blue,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "delivered",
                            child: Text(
                              "Delivered",
                              style: AppTextStyles.body2(
                                fontWeight: FontWeight.w800,
                                color: AppColor.green,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          status = value!;
                          _filterOrderByStatus(orderList);
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 32),
                    categorizedOrder.isEmpty
                        ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.sentiment_dissatisfied_outlined, size: 80),
                                SizedBox(height: 12),
                                Text(
                                  "Tidak ada Pesanan pada kategori ini",
                                  style: AppTextStyles.body1(fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                        : ExpansionTileList(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder:
                              (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Divider(),
                              ),
                          enableTrailingAnimation: false,

                          children: [
                            for (int i = 0; i < categorizedOrder.length; i++)
                              ExpansionTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),

                                backgroundColor: AppColor.mainOrange,
                                collapsedBackgroundColor: AppColor.mainOrange,
                                showTrailingIcon: true,
                                tilePadding: EdgeInsets.symmetric(vertical: 8),
                                collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: IconButton(
                                    onPressed: () {
                                      editOrder(order: categorizedOrder[i]);
                                    },
                                    icon: Icon(Icons.edit, color: AppColor.white),
                                  ),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      Icon(Icons.fastfood_outlined, color: AppColor.white),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          categorizedOrder[i].menu!.title,
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.body1(
                                            fontWeight: FontWeight.w800,
                                            color: AppColor.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                                  child: Row(
                                    children: [
                                      Icon(Icons.access_time, color: AppColor.white),
                                      const SizedBox(width: 16),
                                      Text(
                                        AppDateFormatter.dateMonthYear(
                                          categorizedOrder[i].menu!.date,
                                        ),
                                        style: AppTextStyles.body1(
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    width: double.infinity,
                                    color: AppColor.white,
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: AppColor.mainLightGreen,
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                categorizedOrder[i].deliveryAddress,
                                                style: AppTextStyles.body3(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.receipt, color: AppColor.mainOrange),
                                            const SizedBox(width: 16),
                                            Text(
                                              "Status Pengiriman: ",
                                              style: AppTextStyles.body3(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(left: 4),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _statusColor(
                                                  categorizedOrder[i].status!,
                                                ).withValues(alpha: 0.2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                categorizedOrder[i].status!
                                                    .toUpperCase()
                                                    .replaceAll("_", " "),
                                                style: AppTextStyles.body3(
                                                  fontWeight: FontWeight.bold,
                                                  color: _statusColor(categorizedOrder[i].status!),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.today_outlined, color: AppColor.indigo),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                "Dipesan pada: ${AppDateFormatter.dateMonthYear(categorizedOrder[i].createdAt)}",
                                                style: AppTextStyles.body3(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.money, color: AppColor.blue),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                "Harga: ${MoneyFormatter.toIdr(categorizedOrder[i].menu!.price!)}",
                                                style: AppTextStyles.body3(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                  ],
                ),
              );
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_rounded, size: 80),
                      SizedBox(height: 12),
                      Text(
                        "Tidak ada Riwayat pemesanan",
                        style: AppTextStyles.body1(fontWeight: FontWeight.w600),
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
