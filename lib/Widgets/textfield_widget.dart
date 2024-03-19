import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TextFieldWidget extends StatefulWidget {
  final String? title;
  final String? hintText;
  final int? maxLength;
  final bool? obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final bool? isDisable;
  final void Function(String value)? onChanged;
  final void Function(String? value)? onSaved;
  final FocusNode? focusNode;
  final void Function()? onTap;
  final BoxConstraints? prefixIconConstraints;
  final Widget? prefixIcon;
  final void Function(String value)? onFieldSubmitted;
  final double? textFieldWidth;
  final bool readOnly;
  final BoxConstraints? suffixIconConstraints;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldWidget({
    super.key,
    this.title,
    this.controller,
    this.validator,
    this.hintText,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.obscureText,
    this.suffixIcon,
    this.contentPadding,
    this.isDisable = false,
    this.onChanged,
    this.onSaved,
    this.focusNode,
    this.onTap,
    this.prefixIconConstraints,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.textFieldWidth,
    this.readOnly = false,
    this.suffixIconConstraints,
    this.inputFormatters,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.isPortrait ? null : widget.textFieldWidth ?? 50.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Padding(
              padding: EdgeInsets.only(left: context.isPortrait ? 2.w : 1.w),
              child: Text(
                widget.title!,
                style: TextStyle(
                  color: AppColors.PRIMARY_COLOR,
                  fontSize: context.isPortrait ? 16.sp : 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 1.h),
          ],
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: widget.controller,
            validator: widget.validator,
            focusNode: widget.focusNode,
            style: TextStyle(
              color: AppColors.SECONDARY_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: context.isPortrait ? 15.sp : 9.sp,
            ),
            obscureText: widget.obscureText ?? false,
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
            cursorColor: AppColors.SECONDARY_COLOR,
            enabled: widget.isDisable == false,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            onSaved: widget.onSaved,
            onFieldSubmitted: widget.onFieldSubmitted,
            readOnly: widget.readOnly,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              counter: const SizedBox(),
              counterStyle: TextStyle(color: AppColors.PRIMARY_COLOR),
              filled: true,
              prefixIconConstraints: widget.prefixIconConstraints,
              prefixIcon: widget.prefixIcon,
              fillColor: AppColors.WHITE_COLOR,
              hintText: widget.hintText,
              suffixIconConstraints: widget.suffixIconConstraints,
              suffixIcon: widget.suffixIcon,
              hintStyle: TextStyle(
                color: AppColors.SECONDARY_COLOR.withOpacity(0.5),
                fontSize: context.isPortrait ? 15.sp : 9.sp,
                fontWeight: FontWeight.w600,
              ),
              errorStyle: TextStyle(
                color: AppColors.ERROR_COLOR,
                fontSize: context.isPortrait ? 15.sp : 9.sp,
                fontWeight: FontWeight.w500,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.ERROR_COLOR,
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.ERROR_COLOR,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.PRIMARY_COLOR,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.PRIMARY_COLOR,
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.PRIMARY_COLOR,
                  width: 1,
                ),
              ),
              errorMaxLines: 2,
              isDense: true,
              contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(horizontal: context.isPortrait ? 3.w : 3.h, vertical: context.isPortrait ? 1.h : 1.w).copyWith(right: context.isPortrait ? 1.5.w : 1.5.h),
            ),
          ),
        ],
      ),
    );
  }
}
