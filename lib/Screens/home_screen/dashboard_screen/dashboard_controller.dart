import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  List<String> contentRouteList = [
    Routes.orderDetailsScreen,
  ];

  List<String> contentList = [
    AppStrings.orderDetails,
  ];

  List<String> contentIconList = [
    AppAssets.orderDetailsIcon,
  ];
}
