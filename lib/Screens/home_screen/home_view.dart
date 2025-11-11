import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/hand_shaken_animation.dart';
import 'package:cph_stocks/Screens/home_screen/home_controller.dart';
import 'package:cph_stocks/Screens/home_screen/notes_screen/notes_controller.dart';
import 'package:cph_stocks/Screens/home_screen/recycle_bin_screen/recycle_bin_controller.dart';
import 'package:cph_stocks/Screens/home_screen/settings_screen/settings_controller.dart';
import 'package:cph_stocks/Utils/in_app_update_dialog_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        await showExitDialog(context);
      },
      child: Obx(() {
        return Scaffold(
          key: controller.scaffoldKey,
          backgroundColor: controller.isRecycleBinSelected ? AppColors.PRIMARY_COLOR.withValues(alpha: 0.5) : AppColors.SECONDARY_COLOR,
          drawer: Drawer(
            backgroundColor: AppColors.SECONDARY_COLOR.withValues(alpha: 0.7),
            elevation: 4,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: DrawerHeader(
                      margin: EdgeInsets.zero,
                      child: Image.asset(
                        AppAssets.nativeSplash2Image,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  for (int i = 0; i < controller.drawerItemWidgetList.length; i++) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: AssetImages(
                        index: i,
                        icon: controller.listOfImages[i],
                        iconName: controller.listOfPages[i].tr,
                        iconSize: controller.listOfImageSizes[i],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: controller.isRecycleBinSelected ? AppColors.TRANSPARENT : AppColors.SECONDARY_COLOR,
            leading: Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: DrawerButton(
                color: controller.isRecycleBinSelected ? AppColors.SECONDARY_COLOR : AppColors.PRIMARY_COLOR,
              ),
            ),
            leadingWidth: 15.w,
            titleSpacing: 0.w,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (controller.drawerIndex.value == 0) ...[
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            "${AppStrings.hello.tr}${getData(AppConstance.userName) ?? ""} ",
                            style: AppStyles.size20w700.copyWith(fontWeight: FontWeight.w900, color: AppColors.WHITE_COLOR.withValues(alpha: 0.8)),
                          ),
                        ),
                        const HandShakenAnimation(),
                      ],
                    ),
                  ),
                ] else ...[
                  CustomHeaderWidget(
                    title: controller.listOfPages[controller.drawerIndex.value],
                    titleIcon: controller.listOfTitleAnim[controller.drawerIndex.value],
                    titleIconSize: controller.listOfTitleAnimSize[controller.drawerIndex.value],
                    titleColor: controller.listOfTitleColor[controller.drawerIndex.value],
                  ),
                  if (controller.isRecycleBinSelected) ...[
                    Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: Obx(() {
                        return IconButton(
                          onPressed: Get.find<RecycleBinController>().isRefreshing.value
                              ? () {}
                              : () async {
                                  await Get.find<RecycleBinController>().getOrdersApi(isLoading: false);
                                },
                          style: IconButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                          ),
                          icon: Obx(() {
                            return TweenAnimationBuilder(
                              duration: Duration(seconds: Get.find<RecycleBinController>().isRefreshing.value ? 45 : 1),
                              tween: Tween(begin: 0.0, end: Get.find<RecycleBinController>().isRefreshing.value ? 45.0 : Get.find<RecycleBinController>().ceilValueForRefresh.value),
                              onEnd: () {
                                Get.find<RecycleBinController>().isRefreshing.value = false;
                              },
                              builder: (context, value, child) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Get.find<RecycleBinController>().ceilValueForRefresh(value.toDouble().ceilToDouble());
                                });
                                return Transform.rotate(
                                  angle: value * 2 * 3.141592653589793,
                                  child: Icon(
                                    Icons.refresh_rounded,
                                    color: AppColors.SECONDARY_COLOR,
                                    size: context.isPortrait ? 6.w : 6.h,
                                  ),
                                );
                              },
                            );
                          }),
                        );
                      }),
                    ),
                  ],
                  if (controller.isNotesSelected) ...[
                    Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: Obx(() {
                        return IconButton(
                          onPressed: Get.find<NotesController>().isRefreshing.value
                              ? () {}
                              : () async {
                                  Utils.unfocus();
                                  Get.find<NotesController>().getNotesApi(isLoading: false);
                                },
                          style: IconButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                          ),
                          icon: Obx(() {
                            return TweenAnimationBuilder(
                              duration: Duration(seconds: Get.find<NotesController>().isRefreshing.value ? 45 : 1),
                              tween: Tween(begin: 0.0, end: Get.find<NotesController>().isRefreshing.value ? 45.0 : Get.find<NotesController>().ceilValueForRefresh.value),
                              onEnd: () {
                                Get.find<NotesController>().isRefreshing.value = false;
                              },
                              builder: (context, value, child) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  Get.find<NotesController>().ceilValueForRefresh(value.toDouble().ceilToDouble());
                                });
                                return Transform.rotate(
                                  angle: value * 2 * 3.141592653589793,
                                  child: Icon(
                                    Icons.refresh_rounded,
                                    color: AppColors.PRIMARY_COLOR,
                                    size: context.isPortrait ? 6.w : 6.h,
                                  ),
                                );
                              },
                            );
                          }),
                        );
                      }),
                    ),
                  ],
                  if (controller.isSettingsSelected) ...[
                    Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: Obx(() {
                        return Row(
                          children: [
                            if (controller.isLatestVersionAvailable.isTrue) ...[
                              IconButton(
                                onPressed: () async {
                                  await showUpdateDialog(
                                    isUpdateLoading: Get.find<SettingsController>().isUpdateLoading,
                                    downloadedProgress: Get.find<SettingsController>().downloadedProgress,
                                    onUpdate: () async {
                                      await Get.find<SettingsController>().downloadAndInstallService();
                                    },
                                  );
                                },
                                style: IconButton.styleFrom(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                  maximumSize: Size(6.w, 6.w),
                                  minimumSize: Size(6.w, 6.w),
                                ),
                                icon: Icon(
                                  Icons.arrow_circle_up_rounded,
                                  color: AppColors.DARK_GREEN_COLOR,
                                  size: 6.w,
                                ),
                              ),
                              SizedBox(width: 2.w),
                            ],
                            Obx(() {
                              return Text(
                                AppConstance.appVersion.replaceAll('1.0.0', Get.find<SettingsController>().appVersion.value),
                                style: TextStyle(
                                  color: AppColors.PRIMARY_COLOR.withValues(alpha: 0.55),
                                  fontWeight: FontWeight.w700,
                                  fontSize: context.isPortrait ? 16.sp : 12.sp,
                                ),
                              );
                            }),

                            ///Copy URL
                            if ([AppConstance.admin, AppConstance.manager].contains(getData(AppConstance.role))) ...[
                              SizedBox(width: 2.w),
                              InkWell(
                                onTap: () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: controller.newAPKUrl.value),
                                  );
                                  Utils.handleMessage(message: AppStrings.urlCopied.tr);
                                },
                                child: FaIcon(
                                  FontAwesomeIcons.link,
                                  color: AppColors.PRIMARY_COLOR,
                                  size: 4.w,
                                ),
                              ),
                            ],
                          ],
                        );
                      }),
                    ),
                  ],
                ],
              ],
            ),
          ),
          body: SafeArea(
            child: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: controller.drawerItemWidgetList,
            ),
          ),
        );
      }),
    );
  }

  // ignore: non_constant_identifier_names
  Widget AssetImages({
    required int index,
    required String icon,
    required String iconName,
    double? iconSize,
  }) {
    return InkWell(
      onTap: () async {
        await controller.onDrawerItemChange(index: index);
      },
      borderRadius: BorderRadius.circular(90),
      child: StatefulBuilder(
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            state(() {});
          });
          return SizedBox(
            height: 6.5.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10.w,
                  height: 3.h,
                  child: Obx(() {
                    return Image.asset(
                      icon,
                      width: iconSize ?? 8.w,
                      fit: BoxFit.fitHeight,
                      color: controller.drawerIndex.value == index ? AppColors.TERTIARY_COLOR : AppColors.WHITE_COLOR,
                    );
                  }),
                ),
                SizedBox(width: 2.w),
                Text(
                  iconName,
                  style: AppStyles.size16w600.copyWith(color: controller.drawerIndex.value == index ? AppColors.TERTIARY_COLOR : AppColors.WHITE_COLOR),
                ),
              ],
            ),
          );
        },
      ),
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
