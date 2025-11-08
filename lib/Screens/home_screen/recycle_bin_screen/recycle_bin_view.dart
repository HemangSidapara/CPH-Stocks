import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/recycle_bin_screen/recycle_bin_controller.dart';
import 'package:cph_stocks/Screens/home_screen/recycle_bin_screen/sort_by_pvd_color_screen/sort_by_pvd_color_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RecycleBinView extends GetView<RecycleBinController> {
  const RecycleBinView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(),
      child: Column(
        children: [
          SizedBox(height: 1.h),

          ///Sort by Color
          const Expanded(
            child: SortByPvdColorView(),
          ),
        ],
      ),
    );
  }
}
