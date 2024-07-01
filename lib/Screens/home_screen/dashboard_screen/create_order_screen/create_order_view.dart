import 'dart:convert';

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/order_models/get_parties_model.dart' as get_parties;
import 'package:cph_stocks/Network/services/utils_services/image_picker_service.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_controller.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
    return GestureDetector(
      onTap: () => Utils.unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.5.h),
            child: Column(
              children: [
                ///Header
                CustomHeaderWidget(
                  title: AppStrings.createOrder.tr,
                  titleIcon: AppAssets.createOrderImage,
                  onBackPressed: () {
                    Get.back(closeOverlays: true);
                  },
                ),
                SizedBox(height: 4.h),

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
                                TextButton(
                                  onPressed: () {
                                    controller.partyNameController.clear();
                                    controller.contactNumberController.clear();
                                    controller.selectedParty(-1);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    maximumSize: Size(10.w, 2.5.h),
                                    minimumSize: Size(10.w, 2.5.h),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    AppStrings.reset.tr,
                                    style: TextStyle(
                                      color: AppColors.LIGHT_BLUE_COLOR,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Obx(() {
                            return DropdownSearch<get_parties.Data>(
                              autoValidateMode: AutovalidateMode.onUserInteraction,
                              asyncItems: (text) async {
                                return controller.getPartiesApi();
                              },
                              selectedItem: controller.selectedParty.value == -1 ? null : controller.partyList[controller.selectedParty.value],
                              dropdownButtonProps: DropdownButtonProps(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.SECONDARY_COLOR,
                                  size: 5.w,
                                ),
                              ),
                              validator: controller.validatePartyList,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                baseStyle: TextStyle(
                                  color: AppColors.SECONDARY_COLOR,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                                dropdownSearchDecoration: InputDecoration(
                                  filled: true,
                                  enabled: true,
                                  fillColor: AppColors.WHITE_COLOR,
                                  hintText: AppStrings.selectParty.tr,
                                  hintStyle: TextStyle(
                                    color: AppColors.SECONDARY_COLOR.withOpacity(0.5),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  errorStyle: TextStyle(
                                    color: AppColors.ERROR_COLOR,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.PRIMARY_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.ERROR_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.ERROR_COLOR,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0).copyWith(right: 1.w),
                                ),
                              ),
                              itemAsString: (item) {
                                return item.partyName ?? '';
                              },
                              popupProps: PopupProps.menu(
                                menuProps: MenuProps(
                                  backgroundColor: AppColors.WHITE_COLOR,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                loadingBuilder: (context, searchEntry) {
                                  return Center(
                                    child: LoadingWidget(
                                      loaderColor: AppColors.SECONDARY_COLOR,
                                    ),
                                  );
                                },
                                emptyBuilder: (context, searchEntry) {
                                  return Center(
                                    child: Text(
                                      AppStrings.noDataFound.tr,
                                      style: TextStyle(
                                        color: AppColors.SECONDARY_COLOR.withOpacity(0.5),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                                itemBuilder: (context, item, isSelected) {
                                  return TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      controller.selectedParty.value = controller.partyList.indexWhere((element) => element.orderId == item.orderId);
                                      if (controller.selectedParty.value != -1) {
                                        controller.partyNameController.text = controller.partyList[controller.selectedParty.value].partyName ?? '';
                                        controller.contactNumberController.text = controller.partyList[controller.selectedParty.value].contactNumber ?? '';
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: context.isPortrait ? 5.w : 5.h, vertical: context.isPortrait ? 1.h : 1.w),
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                    ),
                                    child: Text(
                                      item.partyName ?? '',
                                      style: TextStyle(
                                        color: AppColors.SECONDARY_COLOR,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                                interceptCallBacks: true,
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  cursorColor: AppColors.TERTIARY_COLOR,
                                  style: TextStyle(
                                    color: AppColors.SECONDARY_COLOR,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: AppStrings.searchParty.tr,
                                    hintStyle: TextStyle(
                                      color: AppColors.HINT_GREY_COLOR,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: AppColors.SECONDARY_COLOR),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(width: 1, color: AppColors.SECONDARY_COLOR),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: context.isPortrait ? 4.w : 4.h, vertical: context.isPortrait ? 1.2.h : 1.2.w),
                                  ),
                                ),
                              ),
                            );
                          }),
                          SizedBox(height: 1.h),

                          ///Party Name
                          TextFieldWidget(
                            controller: controller.partyNameController,
                            hintText: AppStrings.enterPartyName.tr,
                            validator: controller.validatePartyName,
                            textInputAction: TextInputAction.next,
                            maxLength: 50,
                            isDisable: controller.selectedParty.value != -1,
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
                if (index != 0) ...[
                  TextButton(
                    onPressed: () {
                      controller.itemNameControllerList.add(TextEditingController());
                      controller.pvdColorControllerList.add(TextEditingController());
                      controller.quantityControllerList.add(TextEditingController());
                      controller.sizeControllerList.add(TextEditingController());
                      controller.base64ImageList.add('');
                      controller.isImageSelectedList.add(false);
                      controller.selectedPvdColorList.add(-1);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      maximumSize: Size(10.w, 2.5.h),
                      minimumSize: Size(10.w, 2.5.h),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      AppStrings.add.tr,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.DARK_GREEN_COLOR,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                ],

                ///Add & Remove
                TextButton(
                  onPressed: () {
                    if (index == 0) {
                      controller.itemNameControllerList.add(TextEditingController());
                      controller.pvdColorControllerList.add(TextEditingController());
                      controller.quantityControllerList.add(TextEditingController());
                      controller.sizeControllerList.add(TextEditingController());
                      controller.base64ImageList.add('');
                      controller.isImageSelectedList.add(false);
                      controller.selectedPvdColorList.add(-1);
                    } else {
                      controller.itemNameControllerList.removeAt(index);
                      controller.pvdColorControllerList.removeAt(index);
                      controller.quantityControllerList.removeAt(index);
                      controller.sizeControllerList.removeAt(index);
                      controller.base64ImageList.removeAt(index);
                      controller.isImageSelectedList.removeAt(index);
                      controller.selectedPvdColorList.removeAt(index);
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    maximumSize: Size(index == 0 ? 10.w : 15.w, 2.5.h),
                    minimumSize: Size(index == 0 ? 10.w : 15.w, 2.5.h),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    index == 0 ? AppStrings.add.tr : AppStrings.remove.tr,
                    style: TextStyle(
                      color: index == 0 ? AppColors.DARK_GREEN_COLOR : AppColors.DARK_RED_COLOR,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
              TextButton(
                onPressed: () {
                  controller.pvdColorControllerList[index].clear();
                  controller.selectedPvdColorList[index] = -1;
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  maximumSize: Size(10.w, 2.5.h),
                  minimumSize: Size(10.w, 2.5.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.reset.tr,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.LIGHT_BLUE_COLOR,
                    fontWeight: FontWeight.w900,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        DropdownSearch<String>(
          autoValidateMode: AutovalidateMode.onUserInteraction,
          items: controller.pvdColorList,
          selectedItem: controller.selectedPvdColorList[index] == -1 ? null : controller.pvdColorList[controller.selectedPvdColorList[index]],
          dropdownButtonProps: DropdownButtonProps(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.SECONDARY_COLOR,
              size: 5.w,
            ),
          ),
          validator: (value) => controller.validatePvdColorList(value, index),
          dropdownDecoratorProps: DropDownDecoratorProps(
            baseStyle: TextStyle(
              color: AppColors.SECONDARY_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
            dropdownSearchDecoration: InputDecoration(
              filled: true,
              enabled: true,
              fillColor: AppColors.WHITE_COLOR,
              hintText: AppStrings.selectPvdColor.tr,
              hintStyle: TextStyle(
                color: AppColors.SECONDARY_COLOR.withOpacity(0.5),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              errorStyle: TextStyle(
                color: AppColors.ERROR_COLOR,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.PRIMARY_COLOR,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.PRIMARY_COLOR,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.PRIMARY_COLOR,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.ERROR_COLOR,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.ERROR_COLOR,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0).copyWith(right: 1.w),
            ),
          ),
          itemAsString: (item) {
            return item;
          },
          popupProps: PopupProps.menu(
            menuProps: MenuProps(
              backgroundColor: AppColors.WHITE_COLOR,
              borderRadius: BorderRadius.circular(12),
            ),
            loadingBuilder: (context, searchEntry) {
              return Center(
                child: LoadingWidget(
                  loaderColor: AppColors.SECONDARY_COLOR,
                ),
              );
            },
            emptyBuilder: (context, searchEntry) {
              return Center(
                child: Text(
                  AppStrings.noDataFound.tr,
                  style: TextStyle(
                    color: AppColors.SECONDARY_COLOR.withOpacity(0.5),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
            itemBuilder: (context, item, isSelected) {
              return TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.selectedPvdColorList[index] = controller.pvdColorList.indexWhere((element) => element == item);
                  if (controller.selectedPvdColorList[index] != -1) {
                    controller.pvdColorControllerList[index].text = controller.pvdColorList[controller.selectedPvdColorList[index]];
                  }
                },
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: context.isPortrait ? 5.w : 5.h, vertical: context.isPortrait ? 1.h : 1.w),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: AppColors.SECONDARY_COLOR,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
            interceptCallBacks: true,
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              cursorColor: AppColors.TERTIARY_COLOR,
              style: TextStyle(
                color: AppColors.SECONDARY_COLOR,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.searchPvdColor.tr,
                hintStyle: TextStyle(
                  color: AppColors.HINT_GREY_COLOR,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1, color: AppColors.SECONDARY_COLOR),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(width: 1, color: AppColors.SECONDARY_COLOR),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: context.isPortrait ? 4.w : 4.h, vertical: context.isPortrait ? 1.2.h : 1.2.w),
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        TextFieldWidget(
          controller: controller.pvdColorControllerList[index],
          hintText: AppStrings.enterPVDColor.tr,
          validator: controller.validatePVDColor,
          textInputAction: TextInputAction.next,
          maxLength: 30,
          isDisable: controller.selectedPvdColorList[index] != -1,
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
          maxLength: 10,
        ),
        SizedBox(height: 2.h),

        ///Size
        TextFieldWidget(
          controller: controller.sizeControllerList[index],
          title: AppStrings.size.tr,
          hintText: AppStrings.enterSize.tr,
          validator: controller.validateSize,
          textInputAction: TextInputAction.next,
          maxLength: 20,
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
        SizedBox(height: index < controller.itemNameControllerList.length - 1 ? 2.h : 1.h),
      ],
    );
  }
}
