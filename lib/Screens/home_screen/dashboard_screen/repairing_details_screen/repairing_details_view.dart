import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/repairing_details_screen/repairing_details_controller.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RepairingDetailsView extends GetView<RepairingDetailsController> {
  const RepairingDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
            child: Column(
              children: [
                ///Header
                CustomHeaderWidget(
                  title: AppStrings.repairingDetails.tr,
                  titleIcon: AppAssets.repairingIcon,
                  onBackPressed: () {
                    Get.back(closeOverlays: true);
                  },
                  titleIconSize: 9.w,
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
