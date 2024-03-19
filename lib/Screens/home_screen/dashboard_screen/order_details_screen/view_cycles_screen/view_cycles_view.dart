import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/order_details_screen/view_cycles_screen/view_cycles_controller.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                    Get.back();
                  },
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
