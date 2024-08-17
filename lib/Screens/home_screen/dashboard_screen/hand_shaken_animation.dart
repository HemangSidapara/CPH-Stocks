import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HandShakenAnimation extends StatefulWidget {
  const HandShakenAnimation({super.key});

  @override
  State<HandShakenAnimation> createState() => _HandShakenAnimationState();
}

class _HandShakenAnimationState extends State<HandShakenAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    try {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );

      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 2500), () {
            try {
              _controller.reverse();
            } catch (e) {
              if (kDebugMode) {
                print('HandShakenAnimation Exception :: $e');
              }
            }
          });
        } else if (status == AnimationStatus.dismissed) {
          Future.delayed(const Duration(milliseconds: 2500), () {
            try {
              _controller.forward();
            } catch (e) {
              if (kDebugMode) {
                print('HandShakenAnimation Exception :: $e');
              }
            }
          });
        }
      });

      _controller.forward();
    } catch (e) {
      if (kDebugMode) {
        print('HandShakenAnimation Exception :: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double angle = TweenSequence<double>(
              [
                TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.1), weight: 1),
                TweenSequenceItem(tween: Tween(begin: 0.1, end: -0.1), weight: 1),
                TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.1), weight: 1),
                TweenSequenceItem(tween: Tween(begin: 0.1, end: -0.1), weight: 1),
                TweenSequenceItem(tween: Tween(begin: -0.1, end: 0.0), weight: 1),
              ],
            ).animate(_controller).value *
            2.0 *
            3.14159;

        return Transform.rotate(
          angle: angle,
          child: Text(
            getString(AppConstance.languageCode) != 'gu' && getString(AppConstance.languageCode) != 'hi' ? '👋' : '🙏',
            style: TextStyle(
              color: AppColors.PRIMARY_COLOR,
              fontSize: context.isPortrait ? 21.sp : 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        );
      },
    );
  }
}
