import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/pending_payment_screen/pending_payment_controller.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PendingPaymentView extends GetView<PendingPaymentController> {
  const PendingPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.TRANSPARENT,
        leadingWidth: 0,
        leading: SizedBox.shrink(),
        actionsPadding: EdgeInsets.zero,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: CustomHeaderWidget(
              title: AppStrings.pendingPayment.tr,
              titleIcon: AppAssets.pendingPaymentIcon,
              onBackPressed: () {
                Get.back(closeOverlays: true);
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
