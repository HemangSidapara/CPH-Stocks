import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  List<String> contentRouteList = [
    Routes.orderDetailsScreen,
    Routes.challanScreen,
  ];

  List<String> contentList = [
    AppStrings.orderDetails,
    AppStrings.challan,
  ];

  List<String> contentIconList = [
    AppAssets.orderDetailsIcon,
    AppAssets.challanIcon,
  ];
}
