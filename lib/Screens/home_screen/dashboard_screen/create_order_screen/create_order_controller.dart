import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/app_validators.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/models/order_models/get_categories_model.dart' as get_categories;
import 'package:cph_stocks/Network/models/order_models/get_parties_model.dart' as get_parties;
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateOrderController extends GetxController {
  GlobalKey<FormState> createOrderFormKey = GlobalKey<FormState>();

  TextEditingController partyNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  RxList<TextEditingController> itemNameControllerList = RxList<TextEditingController>();
  RxList<TextEditingController> pvdColorControllerList = RxList<TextEditingController>();
  RxList<TextEditingController> quantityControllerList = RxList<TextEditingController>();
  RxList<TextEditingController> sizeControllerList = RxList<TextEditingController>();
  RxList<TextEditingController> categoryNameControllerList = RxList<TextEditingController>();
  RxList<String> selectedCategoryNameList = RxList();
  RxList<get_categories.CategoryData> categoryList = RxList();
  RxList<String> base64ImageList = RxList();

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
  RxList<int> selectedPvdColorList = RxList();

  RxBool isGetPartiesLoading = true.obs;
  RxList<get_parties.Data> partyList = RxList();
  RxString selectedParty = "".obs;
  RxBool isCreateOrderLoading = false.obs;
  RxList<bool> isImageSelectedList = RxList();

  @override
  void onInit() async {
    super.onInit();
    await Future.wait(
      [
        getPartiesApi(),
        getCategoriesApi(),
      ],
    );
    await setupStoredOrderDetails();
  }

  String? validatePartyName(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseSelectParty.tr;
    }
    return null;
  }

  String? validatePartyList(get_parties.Data? value) {
    if (value == null && partyNameController.text.isEmpty) {
      return AppStrings.pleaseSelectParty.tr;
    }
    return null;
  }

  String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterContactNumber.tr;
    } else if (value.length < 10) {
      return AppStrings.pleaseEnterValidPhoneNumber.tr;
    }
    return null;
  }

  String? validateItemName(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterItemName.tr;
    }
    return null;
  }

  String? validatePvdColorList(String? value, int index) {
    if (value == null && pvdColorControllerList[index].text.isEmpty) {
      return AppStrings.pleaseSelectPvdColor.tr;
    }
    return null;
  }

  String? validatePVDColor(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterPVDColor.tr;
    }
    return null;
  }

  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterQuantity.tr;
    }
    return null;
  }

  String? validateCategoryName(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseSelectCategoryName.tr;
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

  Future<List<get_parties.Data>> getPartiesApi() async {
    try {
      isGetPartiesLoading(true);
      final response = await OrderServices.getPartiesService();
      if (response.isSuccess) {
        get_parties.GetPartiesModel getPartiesModel = get_parties.GetPartiesModel.fromJson(response.response?.data);
        partyList.clear();
        partyList.addAll(getPartiesModel.data ?? []);
      }
      return [...partyList];
    } finally {
      isGetPartiesLoading(false);
    }
  }

  Future<List<get_categories.CategoryData>> getCategoriesApi() async {
    final response = await OrderServices.getCategoriesService();
    if (response.isSuccess) {
      get_categories.GetCategoriesModel getCategoriesModel = get_categories.GetCategoriesModel.fromJson(response.response?.data);
      categoryList.clear();
      categoryList.addAll(getCategoriesModel.data ?? []);
    }
    return [...categoryList];
  }

  Future<void> createOrderApi() async {
    try {
      isCreateOrderLoading(true);
      final isValidate = createOrderFormKey.currentState?.validate();

      if (isValidate == true) {
        if (isImageSelectedList.every((element) => element == true)) {
          List<Map<String, dynamic>> tempMetaList = [];
          for (int i = 0; i < itemNameControllerList.length; i++) {
            tempMetaList.add({
              ApiKeys.itemName: itemNameControllerList[i].text.trim(),
              ApiKeys.pvdColor: pvdColorControllerList[i].text.trim(),
              ApiKeys.quantity: quantityControllerList[i].text.trim(),
              ApiKeys.size: sizeControllerList[i].text.trim(),
              ApiKeys.categoryName: categoryNameControllerList[i].text.trim(),
              ApiKeys.itemImage: base64ImageList[i],
            });
          }
          final response = await OrderServices.createOrderService(
            partyName: partyNameController.text.trim(),
            contactNumber: contactNumberController.text.trim(),
            description: descriptionController.text.trim(),
            meta: tempMetaList,
          );

          if (response.isSuccess) {
            Get.back();
            removeData(AppConstance.setOrderData);
            Utils.handleMessage(message: response.message);
          }
        } else {
          Utils.handleMessage(message: AppStrings.pleaseAddItemImage.tr, isError: true);
        }
      }
    } finally {
      isCreateOrderLoading(false);
    }
  }

  Future<void> setupStoredOrderDetails() async {
    Map<String, dynamic> data = getList(AppConstance.setOrderData).isNotEmpty ? getList(AppConstance.setOrderData).firstOrNull ?? {} : {};

    if (data.isNotEmpty) {
      partyNameController.text = data[ApiKeys.partyName] ?? '';
      selectedParty.value = partyList.firstWhereOrNull((element) => element.partyName == data[ApiKeys.partyName])?.orderId ?? "";
      contactNumberController.text = data[ApiKeys.contactNumber] ?? '';
      descriptionController.text = data[ApiKeys.description] ?? '';

      for (int i = 0; i < (data[ApiKeys.meta]?.length ?? 0); i++) {
        itemNameControllerList.add(TextEditingController());
        pvdColorControllerList.add(TextEditingController());
        selectedPvdColorList.add(-1);
        quantityControllerList.add(TextEditingController());
        sizeControllerList.add(TextEditingController());
        categoryNameControllerList.add(TextEditingController());
        selectedCategoryNameList.add("");
        base64ImageList.add('');
        isImageSelectedList.add(false);

        itemNameControllerList[i].text = data[ApiKeys.meta][i][ApiKeys.itemName] ?? '';
        pvdColorControllerList[i].text = data[ApiKeys.meta][i][ApiKeys.pvdColor] ?? '';
        selectedPvdColorList[i] = pvdColorList.indexOf(data[ApiKeys.meta][i][ApiKeys.pvdColor]);
        quantityControllerList[i].text = data[ApiKeys.meta][i][ApiKeys.quantity] ?? '';
        sizeControllerList[i].text = data[ApiKeys.meta][i][ApiKeys.size] ?? '';
        categoryNameControllerList[i].text = data[ApiKeys.meta][i][ApiKeys.categoryName] ?? '';
        selectedCategoryNameList[i] = categoryList.firstWhereOrNull((element) => element.categoryName == data[ApiKeys.meta][i][ApiKeys.categoryName])?.categoryId ?? '';
        base64ImageList[i] = data[ApiKeys.meta][i][ApiKeys.itemImage] ?? '';
        isImageSelectedList[i] = data[ApiKeys.meta][i][ApiKeys.itemImage]?.toString().isNotEmpty == true;
      }
    } else {
      itemNameControllerList.add(TextEditingController());
      pvdColorControllerList.add(TextEditingController());
      quantityControllerList.add(TextEditingController());
      sizeControllerList.add(TextEditingController());
      categoryNameControllerList.add(TextEditingController());
      selectedCategoryNameList.add("");
      base64ImageList.add('');
      isImageSelectedList.add(false);
      selectedPvdColorList.add(-1);
    }
  }

  Future<void> storeOrderDetails() async {
    Map<String, dynamic> data = {};

    data[ApiKeys.partyName] = partyNameController.text.trim();
    data[ApiKeys.contactNumber] = contactNumberController.text.trim();
    data[ApiKeys.description] = descriptionController.text.trim();
    data[ApiKeys.meta] = [];

    for (int i = 0; i < itemNameControllerList.length; i++) {
      data[ApiKeys.meta].add(
        {
          ApiKeys.itemName: itemNameControllerList[i].text.trim(),
          ApiKeys.pvdColor: pvdColorControllerList[i].text.trim(),
          ApiKeys.quantity: quantityControllerList[i].text.trim(),
          ApiKeys.size: sizeControllerList[i].text.trim(),
          ApiKeys.categoryName: categoryNameControllerList[i].text.trim(),
          ApiKeys.itemImage: base64ImageList[i],
        },
      );
    }

    await Utils.setOrderData(data: data);
  }

  Future<void> showExitDialog({
    required void Function()? onPressed,
    required String title,
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
                  Icons.warning_rounded,
                  color: AppColors.DARK_RED_COLOR,
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

                      ///Yes, sure
                      ButtonWidget(
                        onPressed: onPressed,
                        fixedSize: Size(30.w, 5.h),
                        buttonTitle: AppStrings.yesSure.tr,
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
}
