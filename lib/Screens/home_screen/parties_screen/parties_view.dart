import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Screens/home_screen/parties_screen/parties_controller.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/no_data_found_widget.dart';
import 'package:cph_stocks/Widgets/refresh_indicator_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PartiesView extends GetView<PartiesController> {
  const PartiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: SearchBar(
              controller: controller.searchController,
              hintText: AppStrings.searchParty.tr,
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              backgroundColor: WidgetStatePropertyAll(AppColors.PRIMARY_COLOR),
              constraints: BoxConstraints.tight(Size(double.maxFinite, 5.h)),
              leading: Icon(
                Icons.search_rounded,
                size: 5.w,
                color: AppColors.SECONDARY_COLOR,
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicatorWidget(
              onRefresh: () async {
                await controller.getPartyApiCall(isRefresh: true);
              },
              child: Obx(() {
                if (controller.isLoading.isTrue) {
                  return Center(
                    child: LoadingWidget(),
                  );
                } else if (controller.partyList.isEmpty) {
                  return NoDataFoundWidget(
                    subtitle: AppStrings.noDataFound.tr,
                  );
                } else {
                  return Container();
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
