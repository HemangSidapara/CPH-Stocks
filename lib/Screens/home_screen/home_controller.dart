import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/models/auth_models/get_latest_version_model.dart';
import 'package:cph_stocks/Network/services/auth_services/auth_services.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/account_view.dart';
import 'package:cph_stocks/Screens/home_screen/cash_flow_scren/cash_flow_controller.dart';
import 'package:cph_stocks/Screens/home_screen/cash_flow_scren/cash_flow_view.dart';
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
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RxInt drawerIndex = 0.obs;
  PageController pageController = PageController(initialPage: 0);
  RxBool isLatestVersionAvailable = false.obs;
  RxString newAPKUrl = ''.obs;
  RxString newAPKVersion = ''.obs;

  RxList<String> listOfTitleAnim = [
    "",
    if ([AppConstance.admin, AppConstance.accountant].contains(getData(AppConstance.role))) AppAssets.accountAnim,
    AppAssets.recycleBinAnim,
    if (getData(AppConstance.role) != AppConstance.customer) AppAssets.notesAnim,
    if ([AppConstance.admin].contains(getData(AppConstance.role))) AppAssets.cashFlowAnim,
    AppAssets.settingsAnim,
  ].obs;

  RxList<double?> listOfTitleAnimSize = [
    null,
    if ([AppConstance.admin, AppConstance.accountant].contains(getData(AppConstance.role))) 10.5.w,
    8.5.w,
    if (getData(AppConstance.role) != AppConstance.customer) 8.5.w,
    if ([AppConstance.admin].contains(getData(AppConstance.role))) null,
    7.w,
  ].obs;

  RxList<Color?> listOfTitleColor = [
    null,
    if ([AppConstance.admin, AppConstance.accountant].contains(getData(AppConstance.role))) null,
    AppColors.SECONDARY_COLOR,
    if (getData(AppConstance.role) != AppConstance.customer) null,
    if ([AppConstance.admin].contains(getData(AppConstance.role))) null,
    null,
  ].obs;

  RxList<String> listOfPages = [
    AppStrings.home,
    if ([AppConstance.admin, AppConstance.accountant].contains(getData(AppConstance.role))) AppStrings.account,
    AppStrings.recycleBin,
    if (getData(AppConstance.role) != AppConstance.customer) AppStrings.notes,
    if ([AppConstance.admin].contains(getData(AppConstance.role))) AppStrings.cashFlow,
    AppStrings.settings,
  ].obs;

  RxList<String> listOfImages = [
    AppAssets.homeIcon,
    if ([AppConstance.admin, AppConstance.accountant].contains(getData(AppConstance.role))) AppAssets.calculatorIcon,
    AppAssets.recycleBinIcon,
    if (getData(AppConstance.role) != AppConstance.customer) AppAssets.notesIcon,
    if ([AppConstance.admin].contains(getData(AppConstance.role))) AppAssets.cashFlowIcon,
    AppAssets.settingsIcon,
  ].obs;

  RxList<double?> listOfImageSizes = [
    null,
    if ([AppConstance.admin, AppConstance.accountant].contains(getData(AppConstance.role))) 4.3.w,
    6.w,
    if (getData(AppConstance.role) != AppConstance.customer) 6.w,
    if ([AppConstance.admin].contains(getData(AppConstance.role))) null,
    null,
  ].obs;

  RxList<Widget> drawerItemWidgetList = [
    const DashboardView(),
    if ([AppConstance.admin, AppConstance.accountant].contains(getData(AppConstance.role))) const AccountView(),
    const RecycleBinView(),
    if (getData(AppConstance.role) != AppConstance.customer) const NotesView(),
    if ([AppConstance.admin].contains(getData(AppConstance.role))) const CashFlowView(),
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
    if (getData(AppConstance.gotoCashFlowFromTerminated) == true) {
      onDrawerItemChange(index: listOfImages.indexOf(AppAssets.cashFlowIcon));
      setData(AppConstance.gotoCashFlowFromTerminated, false);
    }
  }

  bool get isRecycleBinSelected => drawerIndex.value == listOfImages.indexOf(AppAssets.recycleBinIcon);

  bool get isNotesSelected => drawerIndex.value == listOfImages.indexOf(AppAssets.notesIcon);

  bool get isCashFlowSelected => drawerIndex.value == listOfImages.indexOf(AppAssets.cashFlowIcon);

  bool get isSettingsSelected => drawerIndex.value == listOfImages.indexOf(AppAssets.settingsIcon);

  Future<void> onDrawerItemChange({required int index}) async {
    scaffoldKey.currentState?.closeDrawer();
    drawerIndex.value = index;
    getLatestVersionApiCall();
    if (isRecycleBinSelected) {
      Get.find<RecycleBinController>().getOrdersApi(isLoading: Get.find<RecycleBinController>().isGetOrdersLoading.isTrue);
    } else if (isNotesSelected) {
      Get.find<NotesController>().getNotesApi(isLoading: false);
    } else if (isCashFlowSelected) {
      Get.find<CashFlowController>().getCashFlowApiCall(isRefresh: true);
    }
    pageController.jumpToPage(drawerIndex.value);
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
