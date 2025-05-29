import 'dart:convert';

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/models/order_models/get_categories_model.dart' as get_categories;
import 'package:cph_stocks/Network/models/order_models/get_parties_model.dart' as get_parties;
import 'package:cph_stocks/Network/services/utils_services/image_picker_service.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/close_button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/divider_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/no_data_found_widget.dart';
import 'package:cph_stocks/Widgets/show_bottom_sheet_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CreateOrderView extends GetView<CreateOrderController> {
  const CreateOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
            child: Column(
              children: [
                ///Header
                CustomHeaderWidget(
                  title: AppStrings.createOrder.tr,
                  titleIcon: AppAssets.createOrderImage,
                  onBackPressed: () async {
                    await controller.showExitDialog(
                      onPressed: () async {
                        Get.back(closeOverlays: true);
                        Get.back(closeOverlays: true);
                        await removeData(AppConstance.setOrderData);
                      },
                      title: AppStrings.areYouSureYouWantToExitCreateOrder.tr,
                    );
                  },
                ),
                SizedBox(height: 2.h),

                ///Fields
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: controller.createOrderFormKey,
                      child: Column(
                        children: [
                          /// Party List
                          Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.partyName.tr,
                                  style: TextStyle(
                                    color: AppColors.PRIMARY_COLOR,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.partyNameController.clear();
                                    controller.contactNumberController.clear();
                                    controller.selectedParty("");
                                    controller.storeOrderDetails();
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
                            controller: controller.partyNameController,
                            hintText: AppStrings.selectParty.tr,
                            validator: controller.validatePartyName,
                            textInputAction: TextInputAction.next,
                            maxLength: 50,
                            readOnly: true,
                            onTap: () async {
                              await showBottomSheetSelectAndAdd(
                                ctx: context,
                                items: controller.partyList,
                                title: AppStrings.party.tr,
                                fieldHint: AppStrings.enterPartyName.tr,
                                searchHint: AppStrings.searchParty.tr,
                                selectedId: controller.selectedParty.isNotEmpty ? controller.selectedParty.value.toInt() : -1,
                                controller: controller.partyNameController,
                                onInit: () async {
                                  return await controller.getPartiesApi();
                                },
                                onSelect: (id) {
                                  controller.selectedParty.value = id.toString();
                                  controller.partyNameController.text = controller.partyList.firstWhereOrNull((element) => element.orderId == controller.selectedParty.value)?.partyName ?? controller.partyNameController.text;
                                  controller.contactNumberController.text = controller.partyList.firstWhereOrNull((element) => element.orderId == controller.selectedParty.value)?.contactNumber ?? controller.contactNumberController.text;
                                  controller.storeOrderDetails();
                                },
                              );
                            },
                          ),
                          SizedBox(height: 2.h),

                          ///Contact Number
                          TextFieldWidget(
                            controller: controller.contactNumberController,
                            title: AppStrings.contactNumber.tr,
                            hintText: AppStrings.enterContactNumber.tr,
                            validator: controller.validateContactNumber,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              TextInputFormatter.withFunction((oldValue, newValue) {
                                if (!newValue.text.isNumericOnly && newValue.text.isNotEmpty) {
                                  return oldValue;
                                } else {
                                  return newValue;
                                }
                              })
                            ],
                            onChanged: (value) {
                              controller.storeOrderDetails();
                            },
                            maxLength: 10,
                          ),
                          SizedBox(height: 2.h),

                          ///Description
                          TextFieldWidget(
                            controller: controller.descriptionController,
                            title: AppStrings.description.tr,
                            hintText: AppStrings.enterDescription.tr,
                            textInputAction: TextInputAction.next,
                            maxLength: 120,
                            maxLines: 3,
                            onChanged: (value) {
                              controller.storeOrderDetails();
                            },
                          ),
                          SizedBox(height: 2.h),

                          ///Item Fields
                          Obx(() {
                            return Column(
                              children: [
                                for (int i = 0; i < controller.itemNameControllerList.length; i++) itemFieldsWidget(context: context, index: i),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                ///Create Order Button
                Obx(() {
                  return ButtonWidget(
                    onPressed: () async {
                      Utils.unfocus();
                      await controller.createOrderApi();
                    },
                    isLoading: controller.isCreateOrderLoading.value,
                    buttonTitle: AppStrings.createOrder.tr,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showSelectImageBottomSheet({required int index}) async {
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
                              controller.base64ImageList[index] = base64Encode(await result.readAsBytes());
                              controller.isImageSelectedList[index] = true;
                              controller.storeOrderDetails();
                            }
                            Get.back();
                          } else if (controller.base64ImageList[index].isEmpty) {
                            controller.isImageSelectedList[index] = false;
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
                              controller.base64ImageList[index] = base64Encode(await result.readAsBytes());
                              controller.isImageSelectedList[index] = true;
                              controller.storeOrderDetails();
                            }
                            Get.back();
                          } else if (controller.base64ImageList[index].isEmpty) {
                            controller.isImageSelectedList[index] = false;
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

  Widget itemFieldsWidget({
    required BuildContext context,
    required int index,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ///Title & Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///Title
            Text(
              '${index + 1}. ${AppStrings.itemDetails.tr}:',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
                color: AppColors.PRIMARY_COLOR,
              ),
            ),

            ///Buttons
            Row(
              children: [
                ///Add
                IconButton(
                  onPressed: () {
                    controller.itemNameControllerList.add(TextEditingController());
                    controller.pvdColorControllerList.add(TextEditingController());
                    controller.quantityControllerList.add(TextEditingController());
                    controller.sizeControllerList.add(TextEditingController());
                    controller.categoryNameControllerList.add(TextEditingController());
                    controller.selectedCategoryNameList.add('');
                    controller.base64ImageList.add('');
                    controller.isImageSelectedList.add(false);
                    controller.selectedPvdColorList.add(-1);
                    controller.storeOrderDetails();
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    maximumSize: Size(8.w, 8.w),
                    minimumSize: Size(8.w, 8.w),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: AppColors.DARK_GREEN_COLOR,
                    size: 5.w,
                  ),
                ),

                ///Remove
                if (index != 0) ...[
                  SizedBox(width: 2.w),
                  IconButton(
                    onPressed: () {
                      controller.itemNameControllerList.removeAt(index);
                      controller.pvdColorControllerList.removeAt(index);
                      controller.quantityControllerList.removeAt(index);
                      controller.sizeControllerList.removeAt(index);
                      controller.categoryNameControllerList.removeAt(index);
                      controller.selectedCategoryNameList.removeAt(index);
                      controller.base64ImageList.removeAt(index);
                      controller.isImageSelectedList.removeAt(index);
                      controller.selectedPvdColorList.removeAt(index);
                      controller.storeOrderDetails();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      maximumSize: Size(8.w, 8.w),
                      minimumSize: Size(8.w, 8.w),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: Icon(
                      Icons.remove_circle_rounded,
                      color: AppColors.DARK_RED_COLOR,
                      size: 5.w,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        Divider(
          color: AppColors.PRIMARY_COLOR,
          thickness: 1,
        ),

        ///Item Name
        TextFieldWidget(
          controller: controller.itemNameControllerList[index],
          title: AppStrings.itemName.tr,
          hintText: AppStrings.enterItemName.tr,
          validator: controller.validateItemName,
          textInputAction: TextInputAction.next,
          maxLength: 30,
          onChanged: (value) {
            controller.storeOrderDetails();
          },
        ),
        SizedBox(height: 2.h),

        ///Category Name
        TextFieldWidget(
          controller: controller.categoryNameControllerList[index],
          title: AppStrings.categoryName.tr,
          hintText: AppStrings.selectCategoryName.tr,
          validator: controller.validateCategoryName,
          textInputAction: TextInputAction.next,
          maxLength: 10,
          readOnly: true,
          onTap: () async {
            await showBottomSheetSelectAndAdd(
              ctx: context,
              items: controller.categoryList,
              title: AppStrings.category.tr,
              fieldHint: AppStrings.enterCategoryName.tr,
              searchHint: AppStrings.searchCategoryName.tr,
              selectedId: controller.selectedCategoryNameList[index].isNotEmpty ? controller.selectedCategoryNameList[index].toInt() : -1,
              controller: controller.categoryNameControllerList[index],
              onSelect: (id) {
                controller.selectedCategoryNameList[index] = id.toString();
                controller.categoryNameControllerList[index].text = controller.categoryList.firstWhereOrNull((element) => element.categoryId == controller.selectedCategoryNameList[index])?.categoryName ?? controller.categoryNameControllerList[index].text;
                controller.storeOrderDetails();
              },
              onInit: () async {
                return await controller.getCategoriesApi();
              },
            );
          },
        ),
        SizedBox(height: 2.h),

        ///PVD Color
        Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.pvdColor.tr,
                style: TextStyle(
                  color: AppColors.PRIMARY_COLOR,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.pvdColorControllerList[index].clear();
                  controller.selectedPvdColorList[index] = -1;
                  controller.storeOrderDetails();
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
          controller: controller.pvdColorControllerList[index],
          hintText: AppStrings.selectPvdColor.tr,
          validator: (value) {
            return controller.validatePvdColorList(value, index);
          },
          textInputAction: TextInputAction.next,
          maxLength: 50,
          readOnly: true,
          onTap: () async {
            await showBottomSheetSelectAndAdd(
              ctx: context,
              items: controller.pvdColorList,
              title: AppStrings.pvdColor.tr,
              fieldHint: AppStrings.enterPVDColor.tr,
              searchHint: AppStrings.searchPvdColor.tr,
              selectedId: controller.selectedPvdColorList[index],
              controller: controller.pvdColorControllerList[index],
              onSelect: (id) {
                controller.selectedPvdColorList[index] = id;
                controller.storeOrderDetails();
              },
            );
          },
        ),
        SizedBox(height: 2.h),

        ///Quantity
        TextFieldWidget(
          controller: controller.quantityControllerList[index],
          title: AppStrings.quantity.tr,
          hintText: AppStrings.enterQuantity.tr,
          validator: controller.validateQuantity,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          maxLength: 5,
          onChanged: (value) {
            controller.storeOrderDetails();
          },
        ),
        SizedBox(height: 2.h),

        ///Size
        TextFieldWidget(
          controller: controller.sizeControllerList[index],
          title: AppStrings.size.tr,
          hintText: AppStrings.enterSize.tr,
          validator: controller.validateSize,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          maxLength: 10,
          onChanged: (value) {
            controller.storeOrderDetails();
          },
        ),
        SizedBox(height: 2.h),

        ///Image
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: context.isPortrait ? 2.w : 1.w),
            child: Text(
              AppStrings.itemImage.tr,
              style: TextStyle(
                color: AppColors.PRIMARY_COLOR,
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
            await showSelectImageBottomSheet(index: index);
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
              if (controller.isImageSelectedList[index] == true) {
                return Column(
                  children: [
                    SizedBox(
                      height: 25.h,
                      child: Image.memory(
                        base64Decode(controller.base64ImageList[index]),
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    ElevatedButton(
                      onPressed: () {
                        controller.base64ImageList[index] = '';
                        controller.isImageSelectedList[index] = false;
                        controller.storeOrderDetails();
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
        SizedBox(height: index < controller.itemNameControllerList.length - 1 ? 2.h : 1.h),
      ],
    );
  }

  Future<void> showBottomSheetSelectAndAdd({
    required BuildContext ctx,
    required List items,
    Future<List> Function()? onInit,
    required String title,
    required String fieldHint,
    required String searchHint,
    required int selectedId,
    bool selectOnly = false,
    required TextEditingController controller,
    required Function(int id) onSelect,
  }) async {
    RxBool isSearch = true.obs;
    RxList itemsList = items.obs;
    RxList searchItemsList = items.obs;
    RxInt selectedIndex = selectedId.obs;
    TextEditingController newController = TextEditingController(text: selectedId == -1 ? controller.text : null);
    if (selectedId == -1 && newController.text.trim().isNotEmpty) {
      isSearch(false);
    }

    RxBool isLoading = false.obs;
    if (onInit != null) {
      isLoading(itemsList.isEmpty);
      onInit.call().then((value) {
        itemsList.clear();
        searchItemsList.clear();
        itemsList.addAll(value);
        searchItemsList.addAll(value);
        isLoading(false);
      });
    }

    void searchItems(value) {
      searchItemsList.clear();
      if (value.isNotEmpty) {
        searchItemsList.addAll(itemsList.where((element) => element is get_parties.Data
            ? element.partyName?.toLowerCase().contains(value.toLowerCase()) == true
            : element is get_categories.CategoryData
                ? element.categoryName?.toLowerCase().contains(value.toLowerCase()) == true
                : element.toString().toLowerCase().contains(value.toLowerCase())));
      } else {
        searchItemsList.addAll([...itemsList]);
      }
    }

    await showBottomSheetWidget(
      context: ctx,
      builder: (context) {
        final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
        return UnfocusWidget(
          child: Padding(
            padding: EdgeInsets.only(bottom: keyboardPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///Close, Title & Select
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CloseButtonWidget(),
                      SizedBox(width: 2.w),
                      Flexible(child: Text(title, textAlign: TextAlign.center, style: AppStyles.size18w600)),
                      SizedBox(width: 2.w),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          if (isSearch.isFalse && newController.text.trim().isNotEmpty && items.every((element) => element.toString().toLowerCase() != newController.text.trim().toLowerCase())) {
                            controller.text = newController.text;
                            onSelect.call(-1);
                          } else if (selectedIndex.value != -1) {
                            controller.text = itemsList.firstOrNull is get_parties.Data
                                ? (searchItemsList.firstWhereOrNull((element) => element.orderId == selectedIndex.value.toString())?.partyName ?? "")
                                : itemsList.firstOrNull is get_categories.CategoryData
                                    ? (searchItemsList.firstWhereOrNull((element) => element.categoryId == selectedIndex.value.toString())?.categoryName ?? "")
                                    : searchItemsList[selectedIndex.value].toString();
                            onSelect.call(selectedIndex.value);
                          } else {
                            controller.clear();
                            onSelect.call(-1);
                          }
                        },
                        child: Text(AppStrings.select.tr, style: AppStyles.size16w600.copyWith(color: AppColors.DARK_GREEN_COLOR)),
                      ),
                    ],
                  ),
                ),
                DividerWidget(),
                SizedBox(height: 2.h),

                ///New Item
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          return TextFieldWidget(
                            hintText: isSearch.isTrue ? searchHint : fieldHint,
                            controller: newController,
                            maxLength: 20,
                            textFieldWidth: double.maxFinite,
                            onChanged: (value) {
                              if (isSearch.isFalse && value.isNotEmpty) {
                                selectedIndex(-1);
                              } else {
                                searchItems(value);
                              }
                            },
                          );
                        }),
                      ),
                      if (!selectOnly) ...[
                        SizedBox(width: 3.w),
                        ElevatedButton(
                          onPressed: () {
                            isSearch.toggle();
                            newController.clear();
                            searchItems("");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.TERTIARY_COLOR.withValues(alpha: 0.9),
                            shape: CircleBorder(),
                            maximumSize: Size(4.5.h, 4.5.h),
                            minimumSize: Size(4.5.h, 4.5.h),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                          ),
                          child: Obx(() {
                            return Icon(
                              isSearch.isTrue ? Icons.add_rounded : Icons.search_rounded,
                              color: AppColors.PRIMARY_COLOR,
                              size: 5.w,
                            );
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 2.h),

                ///Items
                Flexible(
                  child: Obx(() {
                    if (isLoading.isTrue) {
                      return SizedBox(
                        height: 20.h,
                        child: Center(
                          child: LoadingWidget(),
                        ),
                      );
                    } else if (searchItemsList.isEmpty) {
                      return NoDataFoundWidget(
                        subtitle: AppStrings.noDataFound.tr,
                        bottomMargin: 0,
                      );
                    } else {
                      return ListView.separated(
                        itemCount: searchItemsList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              if (searchItemsList[index] is get_parties.Data) {
                                if (selectedIndex.value.toString() != searchItemsList[index].orderId) {
                                  selectedIndex(searchItemsList[index].orderId.toString().toInt());
                                } else {
                                  selectedIndex(-1);
                                }
                              } else if (searchItemsList[index] is get_categories.CategoryData) {
                                if (selectedIndex.value.toString() != searchItemsList[index].categoryId) {
                                  selectedIndex(searchItemsList[index].categoryId.toString().toInt());
                                } else {
                                  selectedIndex(-1);
                                }
                              } else {
                                if (selectedIndex.value != index) {
                                  selectedIndex(index);
                                } else {
                                  selectedIndex(-1);
                                }
                              }
                              if (isSearch.isFalse && newController.text.trim().isNotEmpty) {
                                newController.clear();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      (searchItemsList[index] is get_parties.Data
                                              ? searchItemsList[index].partyName
                                              : searchItemsList[index] is get_categories.CategoryData
                                                  ? searchItemsList[index].categoryName
                                                  : searchItemsList[index])
                                          .toString()
                                          .tr,
                                      style: AppStyles.size16w600.copyWith(fontSize: 16.sp),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Obx(() {
                                    return AnimatedContainer(
                                      duration: 375.milliseconds,
                                      decoration: BoxDecoration(
                                        color: (searchItemsList[index] is get_parties.Data
                                                ? searchItemsList[index].orderId == selectedIndex.value.toString()
                                                : searchItemsList[index] is get_categories.CategoryData
                                                    ? searchItemsList[index].categoryId == selectedIndex.value.toString()
                                                    : selectedIndex.value == index)
                                            ? AppColors.PRIMARY_COLOR
                                            : AppColors.SECONDARY_COLOR,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.PRIMARY_COLOR,
                                          width: 1,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(1.w),
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: AppColors.SECONDARY_COLOR,
                                        size: 4.5.w,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return DividerWidget(color: AppColors.LIGHT_BLACK_COLOR);
                        },
                      );
                    }
                  }),
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
