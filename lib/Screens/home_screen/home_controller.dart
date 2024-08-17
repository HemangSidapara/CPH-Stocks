import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/auth_models/get_latest_version_model.dart';
import 'package:cph_stocks/Network/services/auth_services/auth_services.dart';
import 'package:cph_stocks/Network/services/utils_services/get_package_info_service.dart';
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

class HomeController extends GetxController {
  RxInt bottomIndex = 0.obs;
  PageController pageController = PageController(initialPage: 0);
  RxBool isLatestVersionAvailable = false.obs;
  RxString newAPKUrl = ''.obs;
  RxString newAPKVersion = ''.obs;

  RxList<String> listOfImages = [
    AppAssets.homeIcon,
    AppAssets.recycleBinIcon,
    AppAssets.notesIcon,
    AppAssets.settingsIcon,
  ].obs;

  RxList<Widget> bottomItemWidgetList = [
    const DashboardView(),
    const RecycleBinView(),
    const NotesView(),
    const SettingsView(),
  ].obs;

  @override
  void onInit() {
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
  }

  Future<void> onBottomItemChange({required int index}) async {
    bottomIndex.value = index;
    AuthServices.getLatestVersionService().then((response) async {
      GetLatestVersionModel versionModel = GetLatestVersionModel.fromJson(response.response?.data);
      if (response.isSuccess) {
        newAPKUrl(versionModel.data?.firstOrNull?.appUrl ?? '');
        newAPKVersion(versionModel.data?.firstOrNull?.appVersion ?? '');
        final currentVersion = (await GetPackageInfoService.instance.getInfo()).version;
        if (kDebugMode) {
          print('currentVersion :: $currentVersion');
          print('newVersion :: ${newAPKVersion.value}');
        }
        isLatestVersionAvailable.value = Utils.isUpdateAvailable(currentVersion, versionModel.data?.firstOrNull?.appVersion ?? currentVersion);
      }
    });
    if (index == 1) {
      Get.find<RecycleBinController>().getOrdersApi(isLoading: false);
    } else if (index == 2) {
      Get.find<NotesController>().getNotesApi(isLoading: false);
    }
    pageController.jumpToPage(bottomIndex.value);
  }
}
