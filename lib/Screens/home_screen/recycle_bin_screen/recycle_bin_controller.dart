import 'package:cached_network_image/cached_network_image.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Network/models/order_models/get_orders_model.dart' as get_orders;
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RecycleBinController extends GetxController with GetTickerProviderStateMixin {
  TextEditingController searchPartyController = TextEditingController();
  RxList<get_orders.ColorData> searchedColorDataList = RxList();
  RxList<get_orders.ColorData> tempColorDataList = RxList();
  RxList<get_orders.ColorData> colorDataList = RxList();
  RxBool isGetOrdersLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  Map<String, Color> colorCodes = {
    "Gold": AppColors.GOLD_COLOR,
    "Rosegold": AppColors.ROSEGOLD_COLOR,
    "Black": AppColors.BLACK_COLOR,
    "Grey": AppColors.GREY_COLOR,
    "Bronze": AppColors.BRONZE_COLOR,
  };

  late TabController sortByColorTabController;
  RxInt selectedSortByColorTabIndex = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    await getOrdersApi();
    sortByColorTabController = TabController(length: searchedColorDataList.length, vsync: this);
    sortByColorTabController.addListener(tabListener);
  }

  Future<void> getOrdersApi({bool isLoading = true}) async {
    try {
      isRefreshing(!isLoading);
      isGetOrdersLoading(isLoading);
      final response = await OrderServices.getOrdersService(isRecycleBin: true);

      if (response.isSuccess) {
        get_orders.GetOrdersModel ordersModel = get_orders.GetOrdersModel.fromJson(response.response?.data);
        colorDataList.clear();
        searchedColorDataList.clear();
        colorDataList.addAll(ordersModel.colorData ?? []);
        searchedColorDataList.addAll(ordersModel.colorData ?? []);
        sortByColorTabController = TabController(length: searchedColorDataList.length, vsync: this);
        sortByColorTabController.addListener(tabListener);
        sortByColorTabController.animateTo(selectedSortByColorTabIndex.value);
        if (searchPartyController.text.trim().isNotEmpty) {
          searchPartyName(searchPartyController.text.trim());
        }
      }
    } finally {
      isRefreshing(false);
      isGetOrdersLoading(false);
    }
  }

  Future<void> searchPartyName(String searchedValue) async {
    searchedColorDataList.clear();
    if (searchedValue.isNotEmpty) {
      for (var colorData in colorDataList) {
        var filteredPartyMeta = colorData.partyMeta?.where((element) => element.partyName?.toLowerCase().contains(searchedValue.toLowerCase()) == true).toList();

        if (filteredPartyMeta != null && filteredPartyMeta.isNotEmpty) {
          var clonedItem = colorData.copyWith(partyMeta: filteredPartyMeta);
          searchedColorDataList.add(clonedItem);
        }
      }
    } else {
      searchedColorDataList.addAll(colorDataList);
    }
    sortByColorTabController = TabController(length: searchedColorDataList.length, vsync: this);
    sortByColorTabController.addListener(tabListener);
  }

  void tabListener() {
    selectedSortByColorTabIndex(sortByColorTabController.index);
  }

  Future<void> showItemImageDialog({
    required String itemName,
    required String itemImage,
  }) async {
    await showGeneralDialog(
      context: Get.context!,
      barrierDismissible: false,
      barrierColor: AppColors.SECONDARY_COLOR,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Material(
            color: AppColors.SECONDARY_COLOR,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
              child: Column(
                children: [
                  ///ItemName
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            itemName,
                            style: TextStyle(
                              color: AppColors.PRIMARY_COLOR,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: IconButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                          ),
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppColors.PRIMARY_COLOR,
                            size: 7.w,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///Item Image
                  Center(
                    child: SizedBox(
                      height: 80.h,
                      child: CachedNetworkImage(
                        imageUrl: itemImage,
                        fit: BoxFit.contain,
                        cacheKey: itemImage,
                        progressIndicatorBuilder: (context, url, progress) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.SECONDARY_COLOR,
                              value: progress.progress,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorWidget: (context, error, stackTrace) {
                          return SizedBox(
                            height: 15.h,
                            width: double.maxFinite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_rounded,
                                  size: 6.w,
                                  color: AppColors.ERROR_COLOR,
                                ),
                                Text(
                                  error.toString().replaceAll('Exception: ', ''),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.SECONDARY_COLOR,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
        );
      },
    );
  }
}