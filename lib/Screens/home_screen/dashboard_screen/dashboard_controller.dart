import 'dart:io';

import 'package:brother_printer/brother_printer.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/close_button_widget.dart';
import 'package:cph_stocks/Widgets/divider_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/no_data_found_widget.dart';
import 'package:cph_stocks/Widgets/show_bottom_sheet_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DashboardController extends GetxController {
  /// @function downloadPdf
  /// @description download pdf from file
  /// @param {File} pdfFile - File object
  /// @returns {Future\<File?>} - Returns a Future of a File object
  /// @throws {Exception} - Throws an exception if an error occurs
  Future<File?> downloadPdf({required File pdfFile}) async {
    if (pdfFile.existsSync()) {
      final directory = Directory('/storage/emulated/0/Download');
      if (directory.existsSync()) {
        final filePath = '${directory.path}/${pdfFile.path.split('/').last}';
        return await pdfFile.copy(filePath);
      }
    }
    return null;
  }

  /// @function printPdf
  /// @description print pdf from file
  /// @param {File} pdfFile - File object
  /// @returns {Future\<bool>} - Returns a Future of a boolean value
  /// @throws {Exception} - Throws an exception if an error occurs
  Future<bool> printPdf({required File pdfFile, bool isLandscape = true}) async {
    if (pdfFile.existsSync()) {
      RxBool isSearching = true.obs;
      RxList<BrotherDevice> devicesList = RxList();
      RxInt selectedDeviceIndex = (-1).obs;
      RxBool isPrinting = false.obs;
      RxInt numberOfCopies = 2.obs;
      BrotherPrinter.searchDevices().then((value) {
        devicesList.clear();
        devicesList.addAll(value);
        isSearching(false);
      });

      await showBottomSheetWidget(
        context: Get.context!,
        builder: (context) {
          return Column(
            children: [
              ///Back & Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(right: 2.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Title
                    Text(
                      AppStrings.selectPrinter.tr,
                      style: TextStyle(
                        color: AppColors.PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),

                    ///Back
                    CloseButtonWidget(),
                  ],
                ),
              ),
              DividerWidget(color: AppColors.HINT_GREY_COLOR),
              SizedBox(height: 1.h),

              ///Number of Copies
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (numberOfCopies.value > 1) {
                          numberOfCopies(numberOfCopies.value - 1);
                        }
                      },
                      borderRadius: BorderRadius.circular(360),
                      child: Icon(
                        Icons.remove_circle_outline_rounded,
                        size: 8.w,
                        color: AppColors.DARK_RED_COLOR,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Obx(() {
                      return Text(
                        numberOfCopies.value.toString(),
                        style: AppStyles.size16w600,
                      );
                    }),
                    SizedBox(width: 2.w),
                    InkWell(
                      onTap: () {
                        numberOfCopies(numberOfCopies.value + 1);
                      },
                      borderRadius: BorderRadius.circular(360),
                      child: Icon(
                        Icons.add_circle_outline_rounded,
                        size: 8.w,
                        color: AppColors.DARK_GREEN_COLOR,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.h),

              ///Devices
              Expanded(
                child: Obx(() {
                  if (isSearching.isTrue) {
                    return Center(
                      child: LoadingWidget(),
                    );
                  } else if (devicesList.isEmpty) {
                    return NoDataFoundWidget(
                      subtitle: AppStrings.noPrinterFound.tr,
                    );
                  } else {
                    return ListView.separated(
                      itemCount: devicesList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                      itemBuilder: (context, index) {
                        final device = devicesList[index];
                        return InkWell(
                          onTap: () {
                            selectedDeviceIndex(index);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 0.5.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        device.printerName ?? device.modelName,
                                        style: AppStyles.size16w600.copyWith(fontSize: 16.sp),
                                      ),
                                      Text(
                                        device.modelName,
                                        style: AppStyles.size14w600.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        device.source.name,
                                        style: AppStyles.size14w600.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Obx(() {
                                  return AnimatedContainer(
                                    duration: 375.milliseconds,
                                    decoration: BoxDecoration(
                                      color: selectedDeviceIndex.value == index ? AppColors.PRIMARY_COLOR : AppColors.SECONDARY_COLOR,
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

              ///Print
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Obx(() {
                  return ButtonWidget(
                    onPressed: () async {
                      try {
                        isPrinting(true);
                        if (selectedDeviceIndex.value != -1) {
                          try {
                            await BrotherPrinter.printPDF(
                              path: pdfFile.path,
                              device: devicesList[selectedDeviceIndex.value],
                              copies: numberOfCopies.value,
                            );
                          } on PlatformException catch (e) {
                            Utils.handleMessage(message: e.message, isError: true);
                          }
                        } else {
                          Utils.handleMessage(message: AppStrings.pleaseSelectPrinter.tr, isError: true);
                        }
                      } finally {
                        isPrinting(false);
                      }
                    },
                    isLoading: isPrinting.isTrue,
                    buttonTitle: AppStrings.print.tr,
                  );
                }),
              ),
              SizedBox(height: 5.h),
            ],
          );
        },
      );
    }
    return false;
  }

  /// @function sharePdf
  /// @description share pdf from file
  /// @param {File} pdfFile - File object
  /// @returns {Future\<bool>} - Returns a Future of a boolean value
  /// @throws {Exception} - Throws an exception if an error occurs
  Future<bool> sharePdf({required File pdfFile}) async {
    if (pdfFile.existsSync()) {
      return await Printing.sharePdf(
        bytes: pdfFile.readAsBytesSync(),
        filename: pdfFile.path.split('/').last,
      );
    }
    return false;
  }

  /// @function permissionStatus
  /// @description get permission status
  /// @returns {Future<(PermissionStatus storageStatus, PermissionStatus photosStatus)>} - Returns a Future of a tuple of PermissionStatus objects
  /// @throws {Exception} - Throws an exception if an error occurs
  /// @note Android 13+ (Scoped Storage) – storage not needed, only media access
  /// @note Android ≤ 12 – needs storage and possibly photos
  /// @note iOS – only photos access needed
  /// @note If any permission is permanently denied, open app settings
  /// @note Re-check after opening app settings
  /// @note Request if denied
  /// @note Final check before return
  Future<(PermissionStatus storageStatus, PermissionStatus photosStatus)> permissionStatus() async {
    // Default values
    PermissionStatus storageStatus = PermissionStatus.granted;
    PermissionStatus photosStatus = PermissionStatus.granted;

    Future<void> recheckStatus() async {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final androidVersion = androidInfo.version.sdkInt;
        if (androidVersion >= 33) {
          // Android 13+ (Scoped Storage) – storage not needed, only media access
          photosStatus = await Permission.photos.status;
        } else {
          // Android ≤ 12 – needs storage and possibly photos
          storageStatus = await Permission.storage.status;
        }
      } else {
        // iOS – only photos access needed
        photosStatus = await Permission.photos.status;
      }
    }

    await recheckStatus();

    // If any permission is permanently denied
    if (storageStatus.isPermanentlyDenied || photosStatus.isPermanentlyDenied) {
      if (kDebugMode) {
        print("Permission ::::: PermanentlyDenied");
      }
      await openAppSettings();
    }

    // Re-check
    await recheckStatus();

    // Request if denied
    if (storageStatus.isDenied || photosStatus.isDenied) {
      if (kDebugMode) {
        print("Permission ::::: Denied");
      }

      final requests = <Permission>[];

      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final androidVersion = androidInfo.version.sdkInt;
        if (androidVersion < 33 && storageStatus.isDenied) {
          requests.add(Permission.storage);
        }
        if (photosStatus.isDenied) {
          requests.add(Permission.photos);
        }
      } else {
        if (photosStatus.isDenied) {
          requests.add(Permission.photos);
        }
      }

      if (requests.isNotEmpty) {
        await requests.request();
      }
    }

    // Final check before return
    await recheckStatus();

    return (storageStatus, photosStatus);
  }
}
