import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/order_models/get_orders_model.dart' as get_orders;
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:cph_stocks/Network/services/utils_services/image_picker_service.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderDetailsController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  TextEditingController searchPartyController = TextEditingController();
  TextEditingController searchColorController = TextEditingController();
  RxList<get_orders.PartyData> searchedPartyDataList = RxList();
  RxList<get_orders.PartyData> partyDataList = RxList();
  RxList<get_orders.ColorData> searchedColorDataList = RxList();
  RxList<get_orders.ColorData> colorDataList = RxList();
  RxBool isGetOrdersLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  GlobalKey<FormState> editPartyFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> editItemFormKey = GlobalKey<FormState>();

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    await getOrdersApi();
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

  String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterContactNumber.tr;
    }
    return null;
  }

  Future<void> getOrdersApi({bool isLoading = true}) async {
    try {
      isRefreshing(!isLoading);
      isGetOrdersLoading(isLoading);
      final response = await OrderServices.getOrdersService();

      if (response.isSuccess) {
        get_orders.GetOrdersModel ordersModel = get_orders.GetOrdersModel.fromJson(response.response?.data);
        partyDataList.clear();
        searchedPartyDataList.clear();
        colorDataList.clear();
        searchedColorDataList.clear();
        partyDataList.addAll(ordersModel.partyData ?? []);
        searchedPartyDataList.addAll(ordersModel.partyData ?? []);
        colorDataList.addAll(ordersModel.colorData ?? []);
        searchedColorDataList.addAll(ordersModel.colorData ?? []);
      }
    } finally {
      isRefreshing(false);
      isGetOrdersLoading(false);
    }
  }

  Future<void> updatePartyApi({
    required String orderId,
    required String partyName,
    required String contactNumber,
  }) async {
    final isValidate = editPartyFormKey.currentState?.validate();

    if (isValidate == true) {
      final response = await OrderServices.updatePartyService(
        orderId: orderId,
        partyName: partyName,
        contactNumber: contactNumber,
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
    required String orderMetaId,
  }) async {
    final response = await OrderServices.deleteOrderService(
      orderMetaId: orderMetaId,
    );

    if (response.isSuccess) {
      Get.back();
      await getOrdersApi(isLoading: false).then((value) => Utils.handleMessage(message: response.message));
    }
  }

  Future<void> updateItemApi({
    required String orderMetaId,
    required String itemName,
    required String itemImage,
  }) async {
    final isValidate = editItemFormKey.currentState?.validate();

    if (isValidate == true) {
      if (itemImage.isNotEmpty) {
        final response = await OrderServices.updateItemService(
          orderMetaId: orderMetaId,
          itemName: itemName,
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

  Future<void> searchPartyName(String searchedValue) async {
    searchedPartyDataList.clear();
    if (searchedValue.isNotEmpty) {
      searchedPartyDataList.addAll(partyDataList.where((element) => element.partyName?.toLowerCase().contains(searchedValue.toLowerCase()) == true));
    } else {
      searchedPartyDataList.addAll(partyDataList);
    }
  }

  Future<void> searchColorName(String searchedValue) async {
    searchedColorDataList.clear();
    if (searchedValue.isNotEmpty) {
      searchedColorDataList.addAll(colorDataList.where((element) => element.pvdColor?.toLowerCase().contains(searchedValue.toLowerCase()) == true));
    } else {
      searchedColorDataList.addAll(colorDataList);
    }
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

  Future<void> showDeleteDialog({
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
                  Icons.delete_forever_rounded,
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

                      ///Delete
                      ButtonWidget(
                        onPressed: onPressed,
                        fixedSize: Size(30.w, 5.h),
                        buttonTitle: AppStrings.delete.tr,
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
    required String itemImage,
  }) async {
    TextEditingController itemNameController = TextEditingController(text: itemName);
    RxString initialImage = itemImage.obs;
    RxString base64Image = ''.obs;
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
                              maxLength: 30,
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
                                            backgroundColor: AppColors.SECONDARY_COLOR.withOpacity(0.9),
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
                                          color: AppColors.SECONDARY_COLOR.withOpacity(0.5),
                                        ),
                                        Text(
                                          AppStrings.selectOrCaptureAImage.tr,
                                          style: TextStyle(
                                            color: AppColors.SECONDARY_COLOR.withOpacity(0.5),
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
