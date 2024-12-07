import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:cph_stocks/Screens/home_screen/settings_screen/settings_controller.dart';
import 'package:cph_stocks/Utils/in_app_update_dialog_widget.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: getData(AppConstance.role) != AppConstance.admin && getData(AppConstance.role) != AppConstance.employee,
      bottom: getData(AppConstance.role) != AppConstance.admin && getData(AppConstance.role) != AppConstance.employee,
      left: getData(AppConstance.role) != AppConstance.admin && getData(AppConstance.role) != AppConstance.employee,
      right: getData(AppConstance.role) != AppConstance.admin && getData(AppConstance.role) != AppConstance.employee,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomHeaderWidget(
                    title: AppStrings.settings.tr,
                    titleIcon: AppAssets.settingsAnim,
                    titleIconSize: 7.w,
                    onBackPressed: getData(AppConstance.role) != AppConstance.admin && getData(AppConstance.role) != AppConstance.employee
                        ? () {
                            Get.back();
                          }
                        : null,
                  ),
                  Obx(() {
                    return Row(
                      children: [
                        if (controller.homeController.isLatestVersionAvailable.isTrue) ...[
                          IconButton(
                            onPressed: () async {
                              await showUpdateDialog(
                                isUpdateLoading: controller.isUpdateLoading,
                                downloadedProgress: controller.downloadedProgress,
                                onUpdate: () async {
                                  await controller.downloadAndInstallService();
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
                            AppConstance.appVersion.replaceAll('1.0.0', controller.appVersion.value),
                            style: TextStyle(
                              color: AppColors.PRIMARY_COLOR.withOpacity(0.55),
                              fontWeight: FontWeight.w700,
                              fontSize: context.isPortrait ? 16.sp : 12.sp,
                            ),
                          );
                        }),

                        ///Copy URL
                        if (getData(AppConstance.role) == AppConstance.admin) ...[
                          SizedBox(width: 2.w),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: controller.homeController.newAPKUrl.value),
                              );
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
                ],
              ),
              SizedBox(height: 5.h),

              ///Change Language
              Card(
                color: AppColors.TRANSPARENT,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  controller: controller.expansionTileController,
                  title: Text(
                    AppStrings.changeLanguage.tr,
                    style: TextStyle(
                      color: AppColors.SECONDARY_COLOR,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR,
                  backgroundColor: AppColors.LIGHT_SECONDARY_COLOR,
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
                    SizedBox(height: 1.h),
                    Obx(() {
                      return ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 50.w, minHeight: 0.w, maxWidth: 90.w, minWidth: 90.w),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          crossAxisSpacing: 5.w,
                          childAspectRatio: 3,
                          children: [
                            ///English
                            InkWell(
                              onTap: () async {
                                await setData(AppConstance.languageCode, 'en');
                                await setData(AppConstance.languageCountryCode, 'IN');
                                await Get.updateLocale(
                                  Locale(getString(AppConstance.languageCode) ?? 'en', getString(AppConstance.languageCountryCode) ?? 'IN'),
                                );
                                controller.isGujaratiLang(false);
                                controller.isHindiLang(false);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                                child: Row(
                                  children: [
                                    AnimatedOpacity(
                                      opacity: controller.isGujaratiLang.isFalse && controller.isHindiLang.isFalse ? 1 : 0,
                                      duration: const Duration(milliseconds: 300),
                                      child: Icon(
                                        Icons.done_rounded,
                                        size: 6.w,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      AppStrings.english.tr,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            ///Gujarati
                            InkWell(
                              onTap: () async {
                                await setData(AppConstance.languageCode, 'gu');
                                await setData(AppConstance.languageCountryCode, 'IN');
                                await Get.updateLocale(
                                  Locale(getString(AppConstance.languageCode) ?? 'gu', getString(AppConstance.languageCountryCode) ?? 'IN'),
                                );
                                controller.isGujaratiLang(true);
                                controller.isHindiLang(false);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                                child: Row(
                                  children: [
                                    AnimatedOpacity(
                                      opacity: controller.isGujaratiLang.isTrue ? 1 : 0,
                                      duration: const Duration(milliseconds: 300),
                                      child: Icon(
                                        Icons.done_rounded,
                                        size: 6.w,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      AppStrings.gujarati.tr,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            ///Hindi
                            InkWell(
                              onTap: () async {
                                await setData(AppConstance.languageCode, 'hi');
                                await setData(AppConstance.languageCountryCode, 'IN');
                                await Get.updateLocale(
                                  Locale(getString(AppConstance.languageCode) ?? 'hi', getString(AppConstance.languageCountryCode) ?? 'IN'),
                                );
                                controller.isGujaratiLang(false);
                                controller.isHindiLang(true);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                                child: Row(
                                  children: [
                                    AnimatedOpacity(
                                      opacity: controller.isHindiLang.isTrue ? 1 : 0,
                                      duration: const Duration(milliseconds: 300),
                                      child: Icon(
                                        Icons.done_rounded,
                                        size: 6.w,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      AppStrings.hindi.tr,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.SECONDARY_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                  ],
                ),
              ),
              const Spacer(),

              ///LogOut
              ButtonWidget(
                onPressed: () {
                  clearData();
                  Get.offAllNamed(Routes.signInScreen);
                },
                buttonTitle: AppStrings.logOut.tr,
              ),
              SizedBox(height: 2.h),

              Center(
                child: Text(
                  AppStrings.copyrightContext.replaceAll('2024', DateTime.now().year.toString()),
                  style: TextStyle(
                    color: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.55),
                    fontWeight: FontWeight.w700,
                    fontSize: context.isPortrait ? 14.sp : 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
