import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:flutter/material.dart';

class UnfocusWidget extends StatelessWidget {
  final Widget child;

  const UnfocusWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => Utils.unfocus(), behavior: HitTestBehavior.opaque, child: child);
  }
}
