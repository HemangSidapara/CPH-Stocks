import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:flutter/material.dart';

class RefreshIndicatorWidget extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const RefreshIndicatorWidget({super.key, required this.onRefresh, required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      backgroundColor: AppColors.PRIMARY_COLOR,
      strokeWidth: 3,
      color: AppColors.SECONDARY_COLOR,
      child: child,
    );
  }
}
