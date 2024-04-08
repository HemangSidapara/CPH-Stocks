import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Screens/home_screen/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await showExitDialog(context);
      },
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppColors.SECONDARY_COLOR,
              boxShadow: [
                BoxShadow(
                  color: AppColors.MAIN_BORDER_COLOR.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 80,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < controller.bottomItemWidgetList.length; i++)
                  SizedBox(
                    width: 100.w / controller.bottomItemWidgetList.length,
                    child: AssetImages(
                      index: i,
                      iconName: controller.listOfImages[i],
                    ),
                  ),
              ],
            ),
          ),
          body: PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: controller.bottomItemWidgetList,
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget AssetImages({
    required int index,
    required String iconName,
  }) {
    return InkWell(
      onTap: () async {
        await controller.onBottomItemChange(index: index);
      },
      child: StatefulBuilder(builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          state(() {});
        });
        return SizedBox(
          height: 12.w,
          width: 12.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                return Image.asset(
                  iconName,
                  width: 8.w,
                  color: controller.bottomIndex.value == index ? AppColors.TERTIARY_COLOR : AppColors.WHITE_COLOR,
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Future<void> showExitDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'string',
      transitionDuration: const Duration(milliseconds: 350),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation),
          child: child,
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
            height: context.isPortrait ? 30.h : 60.h,
            width: context.isPortrait ? 80.w : 40.w,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.symmetric(horizontal: context.isPortrait ? 5.w : 5.h, vertical: context.isPortrait ? 2.h : 2.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.exit_to_app_rounded,
                  color: AppColors.WARNING_COLOR,
                  size: context.isPortrait ? 8.w : 8.h,
                ),
                SizedBox(height: context.isPortrait ? 2.h : 2.w),
                Text(
                  AppStrings.areYouSureYouWantToExitTheApp.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.ERROR_COLOR,
                    fontWeight: FontWeight.w600,
                    fontSize: context.isPortrait ? 16.sp : 14.sp,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ///No
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.SECONDARY_COLOR,
                        fixedSize: Size(27.w, 5.h),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        AppStrings.no.tr,
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    ///Yes, exit
                    ElevatedButton(
                      onPressed: () async {
                        await SystemNavigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.DARK_RED_COLOR,
                        fixedSize: Size(33.w, 5.h),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        AppStrings.yesExit.tr,
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.isPortrait ? 2.h : 2.w),
              ],
            ),
          ),
        );
      },
    );
  }
}
