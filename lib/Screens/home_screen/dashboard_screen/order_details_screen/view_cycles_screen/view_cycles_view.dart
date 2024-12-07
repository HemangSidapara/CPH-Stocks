import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/view_cycles_screen/view_cycles_controller.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ViewCyclesView extends GetView<ViewCyclesController> {
  const ViewCyclesView({super.key});

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
                  title: AppStrings.viewCycles.tr,
                  titleIcon: AppAssets.viewCyclesIcon,
                  titleIconSize: 8.w,
                  onBackPressed: () {
                    Get.back(closeOverlays: true);
                  },
                ),
                SizedBox(height: 4.h),

                Expanded(
                  child: Obx(() {
                    if (controller.isGetOrderCycleLoading.isTrue) {
                      return const Center(
                        child: LoadingWidget(),
                      );
                    } else if (controller.orderCycleList.isEmpty) {
                      return Center(
                        child: Text(
                          AppStrings.noDataFound.tr,
                          style: TextStyle(
                            color: AppColors.PRIMARY_COLOR,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    } else {
                      return ListView.separated(
                        itemCount: controller.orderCycleList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            color: AppColors.TRANSPARENT,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ExpansionTile(
                              title: GestureDetector(
                                onLongPress: () async {
                                  showBottomSheetOptions(
                                    onSelect: (isBilledSelect) async {
                                      Get.back();
                                      if (isBilledSelect) {
                                        if (controller.orderCycleList[index].isLastBilled == true) {
                                          await controller.lastBilledCycleApi(
                                            orderCycleId: controller.orderCycleList[index].orderCycleId ?? '',
                                            flag: false,
                                            challanNumber: "",
                                          );
                                        } else {
                                          await Future.delayed(const Duration(milliseconds: 350));
                                          showBottomSheetChallanBilled(
                                            onSave: (value) async {
                                              await controller.lastBilledCycleApi(
                                                orderCycleId: controller.orderCycleList[index].orderCycleId ?? '',
                                                flag: true,
                                                challanNumber: value,
                                                onSuccess: (message) {
                                                  Get.back();
                                                  Utils.handleMessage(message: message);
                                                },
                                              );
                                            },
                                          );
                                        }
                                      } else {
                                        await controller.isDispatchedCycleApi(
                                          orderCycleId: controller.orderCycleList[index].orderCycleId ?? '',
                                          flag: !(controller.orderCycleList[index].isDispatched == true),
                                        );
                                      }
                                    },
                                    isBilled: controller.orderCycleList[index].isLastBilled == true,
                                    isDispatched: controller.orderCycleList[index].isDispatched == true,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}. ',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        controller.orderCycleList[index].createdDate != null || controller.orderCycleList[index].createdDate?.isNotEmpty == true ? DateFormat("MMMM dd, yyyy hh:mm a").format(DateFormat("yyyy-MM-dd, hh:mm a").parse(controller.orderCycleList[index].createdDate!).toLocal()) : '',
                                        style: TextStyle(
                                          color: AppColors.SECONDARY_COLOR,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: controller.arguments.isFromRecycleBin
                                  ? null
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ///Last Billed Cycle
                                        if (controller.orderCycleList[index].isLastBilled == true) ...[
                                          Tooltip(
                                            message: AppStrings.thisIsLastBilledCycle.tr,
                                            child: Icon(
                                              Icons.receipt_long,
                                              color: AppColors.LIGHT_BLUE_COLOR,
                                              size: 6.w,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                        ],

                                        ///Is Dispatched Cycle
                                        if (controller.orderCycleList[index].isDispatched == true) ...[
                                          Tooltip(
                                            message: AppStrings.thisCycleIsDispatched.tr,
                                            child: Icon(
                                              Icons.delivery_dining_rounded,
                                              color: AppColors.ORANGE_COLOR,
                                              size: 6.w,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                        ],

                                        ///Delete
                                        IconButton(
                                          onPressed: () async {
                                            await showDeleteDialog(
                                              onPressed: () async {
                                                await controller.deleteCycleApi(orderCycleId: controller.orderCycleList[index].orderCycleId ?? '');
                                              },
                                              title: AppStrings.deleteCycleText.tr.replaceAll("'Cycle'", "'${controller.orderCycleList[index].createdDate != null || controller.orderCycleList[index].createdDate?.isNotEmpty == true ? DateFormat("MMMM dd, yyyy hh:mm a").format(DateFormat("yyyy-MM-dd, hh:mm a").parse(controller.orderCycleList[index].createdDate!).toLocal()) : ''}'"),
                                            );
                                          },
                                          style: IconButton.styleFrom(
                                            backgroundColor: AppColors.DARK_RED_COLOR,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            padding: EdgeInsets.zero,
                                            elevation: 4,
                                            maximumSize: Size(7.5.w, 7.5.w),
                                            minimumSize: Size(7.5.w, 7.5.w),
                                          ),
                                          icon: Icon(
                                            Icons.delete_forever_rounded,
                                            color: AppColors.PRIMARY_COLOR,
                                            size: 4.w,
                                          ),
                                        ),
                                      ],
                                    ),
                              dense: true,
                              collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                              backgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                              iconColor: AppColors.SECONDARY_COLOR,
                              collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              childrenPadding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
                              children: [
                                Divider(
                                  color: AppColors.HINT_GREY_COLOR,
                                  thickness: 1,
                                ),

                                ///OK Pcs
                                Row(
                                  children: [
                                    Text(
                                      "${AppStrings.okPcs.tr}: ",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                    Text(
                                      controller.orderCycleList[index].okPcs ?? '',
                                      style: TextStyle(
                                        shadows: [
                                          Shadow(
                                            color: AppColors.PRIMARY_COLOR,
                                            blurRadius: 40,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.DARK_GREEN_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),

                                ///W/O Process
                                Row(
                                  children: [
                                    Text(
                                      "${AppStrings.woProcess.tr}: ",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                    Text(
                                      controller.orderCycleList[index].woProcess ?? '',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.DARK_RED_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),

                                ///Pending
                                Row(
                                  children: [
                                    Text(
                                      "${AppStrings.pending.tr}: ",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                    Text(
                                      controller.orderCycleList[index].pending ?? '',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.FACEBOOK_BLUE_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),

                                ///Challan Number
                                if (controller.orderCycleList[index].isLastBilled == true && controller.orderCycleList[index].challanNumber != null && controller.orderCycleList[index].challanNumber?.isNotEmpty == true) ...[
                                  Row(
                                    children: [
                                      Text(
                                        "${AppStrings.challanNumber.tr}: ",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.SECONDARY_COLOR,
                                        ),
                                      ),
                                      Text(
                                        controller.orderCycleList[index].challanNumber ?? '',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.DARK_BLACK_COLOR,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0.5.h),
                                ],

                                ///Creator
                                Row(
                                  children: [
                                    Text(
                                      "${AppStrings.creator.tr}: ",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                    Text(
                                      controller.orderCycleList[index].createdBy ?? '',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ROSEGOLD_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 2.h);
                        },
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
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
                      Obx(() {
                        return ButtonWidget(
                          onPressed: onPressed,
                          isLoading: controller.isDeletingOrderCycleLoading.value,
                          fixedSize: Size(30.w, 5.h),
                          buttonTitle: AppStrings.delete.tr,
                          buttonColor: AppColors.DARK_RED_COLOR,
                          buttonTitleColor: AppColors.PRIMARY_COLOR,
                          loaderColor: AppColors.PRIMARY_COLOR,
                        );
                      }),
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

  Future<void> showBottomSheetOptions({
    required void Function(bool isBilledSelect) onSelect,
    required bool isBilled,
    required bool isDispatched,
  }) async {
    await showModalBottomSheet(
      context: Get.context!,
      constraints: BoxConstraints(maxHeight: 90.h),
      backgroundColor: AppColors.PRIMARY_COLOR,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      useRootNavigator: true,
      barrierLabel: 'string',
      builder: (context) {
        return GestureDetector(
          onTap: () => Utils.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///Title
                Text(
                  AppStrings.options.tr,
                  style: TextStyle(
                    color: AppColors.SECONDARY_COLOR,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(
                  color: AppColors.SECONDARY_COLOR,
                  thickness: 1,
                ),
                SizedBox(height: 5.h),

                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///Billed
                    ElevatedButton(
                      onPressed: () {
                        onSelect.call(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBilled ? AppColors.DARK_GREEN_COLOR : AppColors.SECONDARY_COLOR.withOpacity(0.5),
                        shape: const CircleBorder(),
                        elevation: 4,
                        maximumSize: Size(18.w, 18.w),
                        minimumSize: Size(18.w, 18.w),
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        color: AppColors.WHITE_COLOR,
                        size: 12.w,
                      ),
                    ),

                    ///Dispatch
                    ElevatedButton(
                      onPressed: () {
                        onSelect.call(false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDispatched ? AppColors.ORANGE_COLOR : AppColors.SECONDARY_COLOR.withOpacity(0.5),
                        shape: const CircleBorder(),
                        elevation: 4,
                        maximumSize: Size(18.w, 18.w),
                        minimumSize: Size(18.w, 18.w),
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(
                        Icons.delivery_dining_rounded,
                        color: AppColors.WHITE_COLOR,
                        size: 12.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showBottomSheetChallanBilled({
    required void Function(String value) onSave,
  }) async {
    GlobalKey<FormState> challanFormKey = GlobalKey<FormState>();
    TextEditingController challanController = TextEditingController();
    await showModalBottomSheet(
      context: Get.context!,
      backgroundColor: AppColors.PRIMARY_COLOR,
      constraints: BoxConstraints(maxHeight: 90.h),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      useRootNavigator: true,
      isScrollControlled: true,
      barrierLabel: 'string',
      builder: (context) {
        final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
        return GestureDetector(
          onTap: () => Utils.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h).copyWith(bottom: keyboardPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///Title
                Text(
                  AppStrings.challanNumber.tr,
                  style: TextStyle(
                    color: AppColors.SECONDARY_COLOR,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(
                  color: AppColors.SECONDARY_COLOR,
                  thickness: 1,
                ),
                SizedBox(height: 3.h),

                Form(
                  key: challanFormKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: TextFieldWidget(
                      controller: challanController,
                      title: AppStrings.challan.tr,
                      hintText: '123456',
                      secondaryColor: AppColors.PRIMARY_COLOR,
                      primaryColor: AppColors.SECONDARY_COLOR,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterChallanNumber.tr;
                        }
                        return null;
                      },
                      maxLength: 10,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

                      ///Save
                      Obx(() {
                        return ButtonWidget(
                          onPressed: () {
                            if (challanFormKey.currentState?.validate() == true) {
                              onSave.call(challanController.text.trim());
                            }
                          },
                          isLoading: controller.isBilledOrderCycleLoading.value,
                          fixedSize: Size(30.w, 5.h),
                          buttonTitle: AppStrings.save.tr,
                          buttonColor: AppColors.DARK_RED_COLOR,
                          buttonTitleColor: AppColors.PRIMARY_COLOR,
                          loaderColor: AppColors.PRIMARY_COLOR,
                        );
                      }),
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
