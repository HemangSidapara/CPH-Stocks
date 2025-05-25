import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> showBottomSheetWidget({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
}) async {
  await showModalBottomSheet(
    context: context,
    constraints: BoxConstraints(maxWidth: 100.w, minWidth: 100.w, maxHeight: 90.h, minHeight: 0.h),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    isScrollControlled: true,
    useRootNavigator: true,
    clipBehavior: Clip.hardEdge,
    backgroundColor: AppColors.SECONDARY_COLOR,
    builder: builder,
  );
}
