import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final Color? color;
  final double? thickness;

  const DividerWidget({
    super.key,
    this.color,
    this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? AppColors.PRIMARY_COLOR.withValues(alpha: 0.35),
      thickness: thickness ?? 1.5,
    );
  }
}
