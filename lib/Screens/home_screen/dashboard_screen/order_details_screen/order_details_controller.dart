import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/app_validators.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart' as get_invoices;
import 'package:cph_stocks/Network/models/order_models/get_categories_model.dart' as get_categories;
import 'package:cph_stocks/Network/models/order_models/get_orders_meta_model.dart' as get_orders_meta;
import 'package:cph_stocks/Network/models/order_models/get_orders_model.dart' as get_orders;
import 'package:cph_stocks/Network/services/challan_services/challan_service.dart';
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:cph_stocks/Network/services/utils_services/image_picker_service.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/challan_screen/challan_controller.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/challan_screen/challan_view.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_view.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Utils/progress_dialog.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderDetailsController extends GetxController with GetTickerProviderStateMixin {
  TextEditingController searchPartyController = TextEditingController();
  RxList<get_orders.ColorData> searchedColorDataList = RxList();
  RxList<get_orders.ColorData> tempColorDataList = RxList();
  RxList<get_orders.ColorData> colorDataList = RxList();
  RxBool isGetOrdersLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  GlobalKey<FormState> editPartyFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> editItemFormKey = GlobalKey<FormState>();

  Map<String, Color> colorCodes = {
    "Gold": AppColors.GOLD_COLOR,
    "Rosegold": AppColors.ROSEGOLD_COLOR,
    "Black": AppColors.BLACK_COLOR,
    "Grey": AppColors.GREY_COLOR,
    "Bronze": AppColors.BRONZE_COLOR,
  };

  Map<String, Color> backgroundColorCodes = {
    "Gold": AppColors.GOLD_COLOR.withValues(alpha: 0.5),
    "Rosegold": AppColors.ROSEGOLD_COLOR.withValues(alpha: 0.5),
    "Black": AppColors.SECONDARY_COLOR,
    "Grey": AppColors.TRANSPARENT,
    "Bronze": AppColors.BRONZE_COLOR.withValues(alpha: 0.5),
  };

  Map<String, Color> textColorCodes = {
    "Gold": AppColors.SECONDARY_COLOR,
    "Rosegold": AppColors.SECONDARY_COLOR,
    "Black": AppColors.PRIMARY_COLOR,
    "Grey": AppColors.SECONDARY_COLOR,
    "Bronze": AppColors.SECONDARY_COLOR,
  };

  late TabController sortByColorTabController;
  RxInt selectedSortByColorTabIndex = 0.obs;

  RxBool isDeleteMultipleOrdersEnable = false.obs;
  RxList<String> selectedOrderMetaIdForDeletion = RxList();
  RxBool isDeletingMultipleOrders = false.obs;
  RxBool isGenerateChallan = false.obs;
  RxString selectedPartyForDeletingMultipleOrders = "".obs;

  RxBool isGetCyclesLoading = false.obs;
  RxBool isBilledOrderCycleLoading = false.obs;

  RxBool isRepairScreen = false.obs;

  @override
  void onInit() async {
    super.onInit();
    isRepairScreen(Get.arguments ?? false);
    await getOrdersApi();
    sortByColorTabController = TabController(length: searchedColorDataList.length, vsync: this);
    sortByColorTabController.addListener(tabListener);
  }

  String? validatePartyName(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterPartyName.tr;
    }
    return null;
  }

  String? validateItemName(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterItemName.tr;
    }
    return null;
  }

  String? validateCategoryName(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseSelectCategoryName.tr;
    }
    return null;
  }

  String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterContactNumber.tr;
    }
    return null;
  }

  String? validatePvdColorList(String? value) {
    if (value == null) {
      return AppStrings.pleaseSelectPvdColor.tr;
    }
    return null;
  }

  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterQuantity.tr;
    }
    return null;
  }

  String? validateSize(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterSize.tr;
    } else if (!AppValidators.doubleValidator.hasMatch(value)) {
      return AppStrings.pleaseEnterValidSize.tr;
    }
    return null;
  }

  Color getTextColor(String pvdColor) {
    return textColorCodes[pvdColor] ?? AppColors.SECONDARY_COLOR;
  }

  Future<void> getOrdersApi({bool isLoading = true}) async {
    try {
      isRefreshing(!isLoading);
      isGetOrdersLoading(isLoading);
      final response = await OrderServices.getOrdersService(isRepair: isRepairScreen.value);

      if (response.isSuccess) {
        get_orders.GetOrdersModel ordersModel = get_orders.GetOrdersModel.fromJson(response.response?.data);
        String currentTab = searchedColorDataList.isNotEmpty ? searchedColorDataList[sortByColorTabController.index].pvdColor ?? "" : "";
        colorDataList.clear();
        searchedColorDataList.clear();
        colorDataList.addAll(ordersModel.colorData ?? []);
        searchedColorDataList.addAll(ordersModel.colorData ?? []);
        sortByColorTabController = TabController(length: searchedColorDataList.length, vsync: this);
        sortByColorTabController.addListener(tabListener);
        sortByColorTabController.animateTo(selectedSortByColorTabIndex.value);
        if (searchPartyController.text.trim().isNotEmpty) {
          searchPartyName(searchPartyController.text.trim(), selectedTab: currentTab);
        }
      }
    } finally {
      isRefreshing(false);
      isGetOrdersLoading(false);
    }
  }

  Future<List<get_categories.CategoryData>> getCategoriesApi() async {
    final response = await OrderServices.getCategoriesService();
    if (response.isSuccess) {
      get_categories.GetCategoriesModel getCategoriesModel = get_categories.GetCategoriesModel.fromJson(response.response?.data);
      return [...(getCategoriesModel.data ?? [])];
    }
    return [];
  }

  Future<void> updatePartyApi({
    required String orderId,
    required String partyName,
    required String contactNumber,
    required bool isGst,
  }) async {
    final isValidate = editPartyFormKey.currentState?.validate();

    if (isValidate == true) {
      final response = await OrderServices.updatePartyService(
        orderId: orderId,
        partyName: partyName,
        contactNumber: contactNumber,
        isGst: isGst,
      );

      if (response.isSuccess) {
        Get.back();
        await getOrdersApi(isLoading: false).then((value) => Utils.handleMessage(message: response.message));
      }
    }
  }

  Future<void> deletePartyApi({
    required String orderId,
  }) async {
    final response = await OrderServices.deletePartyService(
      orderId: orderId,
    );

    if (response.isSuccess) {
      Get.back();
      await getOrdersApi(isLoading: false).then((value) => Utils.handleMessage(message: response.message));
    }
  }

  Future<void> deleteOrderApi({
    required List<String> orderMetaId,
  }) async {
    final response = await OrderServices.deleteOrderService(
      orderMetaId: orderMetaId,
    );

    if (response.isSuccess) {
      Get.back();
      await getOrdersApi(isLoading: false).then((value) => Utils.handleMessage(message: response.message));
    }
  }

  Future<void> generateInvoiceApi({
    required List<String> orderMetaIds,
  }) async {
    final response = await ChallanService.generateInvoiceService(
      orderMetaIds: orderMetaIds,
    );

    if (response.isSuccess) {
      Get.back();
      Utils.handleMessage(message: response.message);
      get_invoices.GetInvoicesModel invoicesModel = get_invoices.GetInvoicesModel.fromJson(response.response?.data);
      final invoiceDetails = invoicesModel.data?.firstOrNull;
      ChallanView()
          .showInvoiceBottomSheet(
            ctx: Get.context!,
            partyName: invoiceDetails?.partyName ?? "",
            challanNumber: invoiceDetails?.challanNumber ?? "",
            createdDate: invoiceDetails?.createdDate ?? "",
            invoiceData: invoiceDetails?.invoiceMeta ?? [],
          )
          .then((value) {
            if (Get.isRegistered<ChallanController>()) {
              Get.delete<ChallanController>();
            }
          });
      await getOrdersApi(isLoading: false);
    }
  }

  Future<void> updateItemApi({
    required String orderMetaId,
    required String itemName,
    required String categoryName,
    required String pvdColor,
    required String quantity,
    required String size,
    required String itemImage,
  }) async {
    final isValidate = editItemFormKey.currentState?.validate();

    if (isValidate == true) {
      if (itemImage.isNotEmpty) {
        final response = await OrderServices.updateItemService(
          orderMetaId: orderMetaId,
          itemName: itemName,
          categoryName: categoryName,
          pvdColor: pvdColor,
          quantity: quantity,
          size: size,
          itemImage: itemImage,
        );

        if (response.isSuccess) {
          Get.back();
          await getOrdersApi(isLoading: false).then((value) => Utils.handleMessage(message: response.message));
        }
      } else {
        Utils.handleMessage(message: AppStrings.pleaseAddItemImage.tr, isError: true);
      }
    }
  }

  Future<void> getOrdersMetaApi({
    required String createdDate,
    required String createdTime,
    required String pvdColor,
    required void Function(bool isSuccess, List<get_orders_meta.Data>? data) onResponse,
  }) async {
    try {
      isGetCyclesLoading(true);
      final response = await OrderServices.getOrdersMetaService(
        createdDate: createdDate,
        createdTime: createdTime,
        pvdColor: pvdColor,
      );

      onResponse.call(response.isSuccess, get_orders_meta.GetOrdersMetaModel.fromJson(response.response?.data).data);
    } finally {
      isGetCyclesLoading(false);
    }
  }

  Future<void> multipleLastBilledCycleApi({
    required List<String> orderCycleId,
    required String challanNumber,
    required bool flag,
    Function(String message)? onSuccess,
  }) async {
    try {
      isBilledOrderCycleLoading(true);
      final response = await OrderServices.multipleLastBilledCycleService(
        orderCycleId: orderCycleId,
        challanNumber: challanNumber,
        flag: flag,
      );

      if (response.isSuccess) {
        Get.back();
        getOrdersApi(isLoading: false);
        Utils.handleMessage(message: response.message);
      }
    } finally {
      isBilledOrderCycleLoading(false);
    }
  }

  Future<void> searchPartyName(String searchedValue, {String? selectedTab}) async {
    String currentTab = selectedTab ?? (searchedColorDataList.isNotEmpty ? searchedColorDataList[sortByColorTabController.index].pvdColor ?? '' : "");
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
    final currentIndex = searchedColorDataList.indexWhere((element) => element.pvdColor == currentTab);
    if (currentTab.isNotEmpty && currentIndex != -1 && sortByColorTabController.length - 1 > currentIndex) {
      sortByColorTabController.animateTo(currentIndex);
    }
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
                      child: InteractiveViewer(
                        maxScale: 5.0,
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

  Future<void> showDeleteDialog({
    required void Function()? onPressed,
    required String title,
    IconData? iconData,
    Color? iconColor,
    String? agreeText,
  }) async {
    await showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: 'string',
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: AppColors.WHITE_COLOR,
          surfaceTintColor: AppColors.WHITE_COLOR,
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.WHITE_COLOR,
            ),
            width: 80.w,
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 2.h),
                Icon(
                  iconData ?? Icons.delete_forever_rounded,
                  color: iconColor ?? AppColors.DARK_RED_COLOR,
                  size: 8.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.SECONDARY_COLOR,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 3.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Cancel
                      ButtonWidget(
                        onPressed: () {
                          Get.back();
                        },
                        fixedSize: Size(30.w, 5.h),
                        buttonTitle: AppStrings.cancel.tr,
                        buttonColor: AppColors.DARK_GREEN_COLOR,
                        buttonTitleColor: AppColors.PRIMARY_COLOR,
                      ),

                      ///Delete
                      ButtonWidget(
                        onPressed: onPressed,
                        fixedSize: Size(30.w, 5.h),
                        buttonTitle: agreeText ?? AppStrings.delete.tr,
                        buttonColor: AppColors.DARK_RED_COLOR,
                        buttonTitleColor: AppColors.PRIMARY_COLOR,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showEditItemBottomSheet({
    required String orderMetaId,
    required String itemName,
    required String categoryName,
    required String pvdColor,
    required String quantity,
    required String pending,
    required String size,
    required String itemImage,
  }) async {
    RxList<get_categories.CategoryData> categoryList = RxList();
    RxString selectedCategoryName = '-1'.obs;
    getCategoriesApi().then((value) {
      categoryList.clear();
      categoryList.addAll(value);
      selectedCategoryName.value = categoryList.firstWhereOrNull((element) => element.categoryName == categoryName)?.categoryId.toString() ?? "-1";
    });
    TextEditingController itemNameController = TextEditingController(text: itemName);
    TextEditingController categoryNameController = TextEditingController(text: categoryName);
    TextEditingController pvdColorController = TextEditingController(text: pvdColor);
    TextEditingController quantityController = TextEditingController(text: quantity);
    TextEditingController sizeController = TextEditingController(text: size);
    RxList<String> pvdColorList = RxList(
      [
        "Gold",
        "Rosegold",
        "Black",
        "Grey",
        "Bronze",
        "Rainbow",
      ],
    );
    int selectedPvdColor = pvdColorList.indexOf(pvdColor);
    RxString initialImage = itemImage.obs;

    RxString base64Image = ''.obs;

    try {
      Get.put(ProgressDialog()).showProgressDialog(true);
      dio.Response<List<int>> response = await dio.Dio().get<List<int>>(
        itemImage,
        options: dio.Options(responseType: dio.ResponseType.bytes),
      );
      Get.put(ProgressDialog()).showProgressDialog(false);

      if (response.statusCode! >= 200 && response.statusCode! <= 299 && response.data != null) {
        base64Image.value = base64Encode(response.data!);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Image Load Exception: $e");
      }
    }

    RxBool isImageSelected = base64Image.isEmpty && initialImage.isEmpty ? false.obs : true.obs;
    await showModalBottomSheet(
      context: Get.context!,
      constraints: BoxConstraints(maxWidth: 100.w, minWidth: 100.w, maxHeight: 90.h, minHeight: 0.h),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      useRootNavigator: true,
      clipBehavior: Clip.hardEdge,
      backgroundColor: AppColors.WHITE_COLOR,
      builder: (context) {
        final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
        return GestureDetector(
          onTap: () => Utils.unfocus(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.PRIMARY_COLOR,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h).copyWith(bottom: keyboardPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///Back & Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Title
                      Text(
                        AppStrings.editItemDetails.tr,
                        style: TextStyle(
                          color: AppColors.SECONDARY_COLOR,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                      ),

                      ///Back
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: Icon(
                          Icons.close_rounded,
                          color: AppColors.SECONDARY_COLOR,
                          size: 6.w,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: AppColors.HINT_GREY_COLOR,
                    thickness: 1,
                  ),
                  SizedBox(height: 2.h),

                  Flexible(
                    child: Form(
                      key: editItemFormKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ///Item Name
                            TextFieldWidget(
                              controller: itemNameController,
                              title: AppStrings.itemName.tr,
                              hintText: AppStrings.enterItemName.tr,
                              validator: validateItemName,
                              textInputAction: TextInputAction.next,
                              maxLength: 50,
                              primaryColor: AppColors.SECONDARY_COLOR,
                              secondaryColor: AppColors.PRIMARY_COLOR,
                            ),
                            SizedBox(height: 1.h),

                            ///Category Name
                            TextFieldWidget(
                              controller: categoryNameController,
                              title: AppStrings.categoryName.tr,
                              hintText: AppStrings.selectCategoryName.tr,
                              validator: validateCategoryName,
                              textInputAction: TextInputAction.next,
                              maxLength: 10,
                              primaryColor: AppColors.SECONDARY_COLOR,
                              secondaryColor: AppColors.PRIMARY_COLOR,
                              readOnly: true,
                              onTap: () async {
                                await CreateOrderView().showBottomSheetSelectAndAdd(
                                  ctx: context,
                                  items: categoryList,
                                  title: AppStrings.category.tr,
                                  fieldHint: AppStrings.enterCategoryName.tr,
                                  searchHint: AppStrings.searchCategoryName.tr,
                                  selectedId: selectedCategoryName.isNotEmpty ? selectedCategoryName.value.toInt() : -1,
                                  controller: categoryNameController,
                                  onSelect: (id) {
                                    selectedCategoryName.value = id.toString();
                                    categoryNameController.text = categoryList.firstWhereOrNull((element) => element.categoryId == selectedCategoryName.value)?.categoryName ?? categoryNameController.text;
                                  },
                                  selectOnly: true,
                                );
                              },
                            ),
                            SizedBox(height: 1.h),

                            if (quantity == pending || (getData(AppConstance.phone) != null && getData(AppConstance.phone)?.toString().isNotEmpty == true ? AppConstance.editOrderAccess.contains(getData(AppConstance.phone)) : true)) ...[
                              ///PVD Color
                              Padding(
                                padding: EdgeInsets.only(left: 2.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppStrings.pvdColor.tr,
                                      style: TextStyle(
                                        color: AppColors.SECONDARY_COLOR,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        pvdColorController.clear();
                                        selectedPvdColor = -1;
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        maximumSize: Size(6.w, 6.w),
                                        minimumSize: Size(6.w, 6.w),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      icon: Icon(
                                        Icons.refresh_rounded,
                                        color: AppColors.LIGHT_BLUE_COLOR,
                                        size: 5.w,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 1.h),
                              TextFieldWidget(
                                controller: pvdColorController,
                                hintText: AppStrings.selectPvdColor.tr,
                                validator: validatePvdColorList,
                                textInputAction: TextInputAction.next,
                                primaryColor: AppColors.SECONDARY_COLOR,
                                secondaryColor: AppColors.PRIMARY_COLOR,
                                maxLength: 50,
                                readOnly: true,
                                onTap: () async {
                                  await CreateOrderView().showBottomSheetSelectAndAdd(
                                    ctx: context,
                                    items: pvdColorList,
                                    title: AppStrings.pvdColor.tr,
                                    fieldHint: AppStrings.enterPVDColor.tr,
                                    searchHint: AppStrings.searchPvdColor.tr,
                                    selectedId: selectedPvdColor,
                                    controller: pvdColorController,
                                    onSelect: (id) {
                                      selectedPvdColor = id;
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 1.h),

                              ///Quantity
                              TextFieldWidget(
                                controller: quantityController,
                                title: AppStrings.quantity.tr,
                                hintText: AppStrings.enterQuantity.tr,
                                validator: validateQuantity,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                primaryColor: AppColors.SECONDARY_COLOR,
                                secondaryColor: AppColors.PRIMARY_COLOR,
                              ),
                              SizedBox(height: 1.h),
                            ],

                            ///Size
                            TextFieldWidget(
                              controller: sizeController,
                              title: AppStrings.size.tr,
                              hintText: AppStrings.enterSize.tr,
                              validator: validateSize,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              maxLength: 20,
                              primaryColor: AppColors.SECONDARY_COLOR,
                              secondaryColor: AppColors.PRIMARY_COLOR,
                            ),
                            SizedBox(height: 1.h),

                            ///Image
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: context.isPortrait ? 2.w : 1.w),
                                child: Text(
                                  AppStrings.itemImage.tr,
                                  style: TextStyle(
                                    color: AppColors.SECONDARY_COLOR,
                                    fontSize: context.isPortrait ? 16.sp : 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            InkWell(
                              onTap: () async {
                                Utils.unfocus();
                                await showSelectImageBottomSheet(
                                  base64Image: base64Image,
                                  isImageSelected: isImageSelected,
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.symmetric(vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: AppColors.PRIMARY_COLOR,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.LIGHT_BLUE_COLOR,
                                    width: 2.5,
                                  ),
                                ),
                                child: Obx(() {
                                  if (isImageSelected.isTrue) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 25.h,
                                          child: base64Image.isNotEmpty
                                              ? Image.memory(
                                                  base64Decode(base64Image.value),
                                                  fit: BoxFit.contain,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: initialImage.value,
                                                  cacheKey: initialImage.value,
                                                  progressIndicatorBuilder: (context, url, progress) {
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                        color: AppColors.SECONDARY_COLOR,
                                                        strokeWidth: 2,
                                                        value: progress.progress,
                                                      ),
                                                    );
                                                  },
                                                ),
                                        ),
                                        SizedBox(height: 2.h),
                                        ElevatedButton(
                                          onPressed: () {
                                            base64Image.value = '';
                                            isImageSelected.value = false;
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.SECONDARY_COLOR.withValues(alpha: 0.9),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            fixedSize: Size(40.w, 5.h),
                                          ),
                                          child: Text(
                                            AppStrings.remove.tr,
                                            style: TextStyle(
                                              color: AppColors.PRIMARY_COLOR,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        Icon(
                                          Icons.image_rounded,
                                          size: 8.5.w,
                                          color: AppColors.SECONDARY_COLOR.withValues(alpha: 0.5),
                                        ),
                                        Text(
                                          AppStrings.selectOrCaptureAImage.tr,
                                          style: TextStyle(
                                            color: AppColors.SECONDARY_COLOR.withValues(alpha: 0.5),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }),
                              ),
                            ),
                            SizedBox(height: 2.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ///Cancel
                                ElevatedButton(
                                  onPressed: () async {
                                    Get.back();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.DARK_RED_COLOR,
                                    fixedSize: Size(35.w, 5.h),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    AppStrings.cancel.tr,
                                    style: TextStyle(
                                      color: AppColors.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),

                                ///Update
                                ElevatedButton(
                                  onPressed: () async {
                                    Utils.unfocus();
                                    await updateItemApi(
                                      orderMetaId: orderMetaId,
                                      itemName: itemNameController.text.trim(),
                                      categoryName: categoryNameController.text.trim(),
                                      pvdColor: pvdColorController.text.trim(),
                                      quantity: quantityController.text.trim(),
                                      size: sizeController.text.trim(),
                                      itemImage: base64Image.value,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.DARK_GREEN_COLOR,
                                    fixedSize: Size(35.w, 5.h),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    AppStrings.edit.tr,
                                    style: TextStyle(
                                      color: AppColors.PRIMARY_COLOR,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showSelectImageBottomSheet({
    required RxString base64Image,
    required RxBool isImageSelected,
  }) async {
    await showModalBottomSheet(
      context: Get.context!,
      constraints: BoxConstraints(maxWidth: 100.w, minWidth: 100.w, maxHeight: 90.h, minHeight: 0.h),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      useRootNavigator: true,
      clipBehavior: Clip.hardEdge,
      backgroundColor: AppColors.WHITE_COLOR,
      builder: (context) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///Back & Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.select.tr,
                      style: TextStyle(
                        color: AppColors.SECONDARY_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.SECONDARY_COLOR,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: AppColors.HINT_GREY_COLOR,
                  thickness: 1,
                ),
                SizedBox(height: 3.h),

                ///Select Method
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ///Gallery
                      InkWell(
                        onTap: () async {
                          final selectedImage = await ImagePickerService.pickImage(source: ImageSource.gallery);
                          if (selectedImage != null) {
                            final fileFormat = selectedImage.$2.path.split('/').last.split('.').last;
                            XFile? result = await FlutterImageCompress.compressAndGetFile(
                              selectedImage.$2.absolute.path,
                              "${selectedImage.$2.path.split(selectedImage.$2.path.split('/').last).first}optimize_${selectedImage.$2.path.split('/').last}",
                              quality: 50,
                              inSampleSize: 4,
                              format: fileFormat == 'png'
                                  ? CompressFormat.png
                                  : fileFormat == 'jpg' || fileFormat == 'jpeg'
                                  ? CompressFormat.jpeg
                                  : fileFormat == 'heic'
                                  ? CompressFormat.heic
                                  : CompressFormat.webp,
                            );
                            if (result != null) {
                              base64Image.value = base64Encode(await result.readAsBytes());
                              isImageSelected.value = true;
                            }
                            Get.back();
                          } else if (base64Image.value.isEmpty) {
                            isImageSelected.value = false;
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_rounded,
                              color: AppColors.MAIN_BORDER_COLOR,
                              size: 12.w,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              AppStrings.gallery.tr,
                              style: TextStyle(
                                color: AppColors.SECONDARY_COLOR,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///Camera
                      InkWell(
                        onTap: () async {
                          final selectedImage = await ImagePickerService.pickImage(source: ImageSource.camera);
                          if (selectedImage != null) {
                            final fileFormat = selectedImage.$2.path.split('/').last.split('.').last;
                            XFile? result = await FlutterImageCompress.compressAndGetFile(
                              selectedImage.$2.absolute.path,
                              "${selectedImage.$2.path.split(selectedImage.$2.path.split('/').last).first}optimize_${selectedImage.$2.path.split('/').last}",
                              quality: 50,
                              inSampleSize: 4,
                              format: fileFormat == 'png'
                                  ? CompressFormat.png
                                  : fileFormat == 'jpg' || fileFormat == 'jpeg'
                                  ? CompressFormat.jpeg
                                  : fileFormat == 'heic'
                                  ? CompressFormat.heic
                                  : CompressFormat.webp,
                            );
                            if (result != null) {
                              base64Image.value = base64Encode(await result.readAsBytes());
                              isImageSelected.value = true;
                            }
                            Get.back();
                          } else if (base64Image.value.isEmpty) {
                            isImageSelected.value = false;
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_camera_rounded,
                              color: AppColors.MAIN_BORDER_COLOR,
                              size: 12.w,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              AppStrings.camera.tr,
                              style: TextStyle(
                                color: AppColors.SECONDARY_COLOR,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
