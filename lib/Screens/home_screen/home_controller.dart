import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/models/auth_models/get_latest_version_model.dart';
import 'package:cph_stocks/Network/services/auth_services/auth_services.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/account_view.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/dashboard_view.dart';
import 'package:cph_stocks/Screens/home_screen/notes_screen/notes_controller.dart';
import 'package:cph_stocks/Screens/home_screen/notes_screen/notes_view.dart';
import 'package:cph_stocks/Screens/home_screen/recycle_bin_screen/recycle_bin_controller.dart';
import 'package:cph_stocks/Screens/home_screen/recycle_bin_screen/recycle_bin_view.dart';
import 'package:cph_stocks/Screens/home_screen/settings_screen/settings_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeController extends GetxController {
  RxInt bottomIndex = 0.obs;
  PageController pageController = PageController(initialPage: 0);
  RxBool isLatestVersionAvailable = false.obs;
  RxString newAPKUrl = ''.obs;
  RxString newAPKVersion = ''.obs;

  RxList<String> listOfImages = [
    AppAssets.homeIcon,
    if ([AppConstance.admin, AppConstance.accountant].contains(getData(AppConstance.role))) AppAssets.calculatorIcon,
    AppAssets.recycleBinIcon,
    if (getData(AppConstance.role) != AppConstance.customer) AppAssets.notesIcon,
    AppAssets.settingsIcon,
  ].obs;

  RxList<double?> listOfImageSizes = [
    null,
    if ([AppConstance.admin, AppConstance.accountant].contains(getData(AppConstance.role))) 4.3.w,
    6.w,
    if (getData(AppConstance.role) != AppConstance.customer) 6.w,
    null,
  ].obs;

  RxList<Widget> bottomItemWidgetList = [
    const DashboardView(),
    if ([AppConstance.admin, AppConstance.accountant].contains(getData(AppConstance.role))) const AccountView(),
    const RecycleBinView(),
    if (getData(AppConstance.role) != AppConstance.customer) const NotesView(),
    const SettingsView(),
  ].obs;

  @override
  void onInit() async {
    super.onInit();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.SECONDARY_COLOR,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: AppColors.SECONDARY_COLOR,
        statusBarBrightness: Brightness.light,
      ),
    );

    await checkTokenApiCall();
  }

  Future<void> onBottomItemChange({required int index}) async {
    bottomIndex.value = index;
    getLatestVersionApiCall();
    if (index == listOfImages.indexOf(AppAssets.recycleBinIcon)) {
      Get.find<RecycleBinController>().getOrdersApi(isLoading: Get.find<RecycleBinController>().isGetOrdersLoading.isTrue);
    } else if (index == listOfImages.indexOf(AppAssets.notesIcon)) {
      Get.find<NotesController>().getNotesApi(isLoading: false);
    }
    pageController.jumpToPage(bottomIndex.value);
  }

  Future<void> getLatestVersionApiCall() async {
    await AuthServices.getLatestVersionService().then((response) async {
      GetLatestVersionModel versionModel = GetLatestVersionModel.fromJson(response.response?.data);
      if (response.isSuccess) {
        newAPKUrl(versionModel.data?.firstOrNull?.appUrl ?? '');
        newAPKVersion(versionModel.data?.firstOrNull?.appVersion ?? '');
        final currentVersion = (await PackageInfo.fromPlatform()).version;
        if (kDebugMode) {
          print('currentVersion :: $currentVersion');
          print('newVersion :: ${newAPKVersion.value}');
        }
        isLatestVersionAvailable.value = Utils.isUpdateAvailable(currentVersion, versionModel.data?.firstOrNull?.appVersion ?? currentVersion);
      }
    });
  }

  Future<void> checkTokenApiCall() async {
    await AuthServices.checkTokenService();
  }
}
