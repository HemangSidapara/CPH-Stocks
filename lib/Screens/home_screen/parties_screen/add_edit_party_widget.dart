import 'package:cph_stocks/Constants/api_keys.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:cph_stocks/Screens/home_screen/parties_screen/parties_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/close_button_widget.dart';
import 'package:cph_stocks/Widgets/divider_widget.dart';
import 'package:cph_stocks/Widgets/show_bottom_sheet_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> showBottomSheetAddEditParty({
  required BuildContext ctx,
  String? partyId,
  required PartiesController controller,
}) async {
  await showBottomSheetWidget(
    context: ctx,
    builder: (context) {
      return _AddEditParty(
        controller: controller,
        partyId: partyId,
      );
    },
  );
}

class _AddEditParty extends StatefulWidget {
  final String? partyId;
  final PartiesController controller;

  const _AddEditParty({
    this.partyId,
    required this.controller,
  });

  @override
  State<_AddEditParty> createState() => _AddEditPartyState();
}

class _AddEditPartyState extends State<_AddEditParty> {
  GlobalKey<FormState> addEditFormKey = GlobalKey<FormState>();

  TextEditingController partyNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController pendingBalanceController = TextEditingController(text: "0.0");
  TextEditingController referenceNameController = TextEditingController();
  TextEditingController referenceNumberController = TextEditingController();
  RxString paymentType = "".obs;

  RxBool isSaving = false.obs;

  @override
  void initState() {
    super.initState();
    if (widget.partyId != null) {
      final partyData = widget.controller.partyList.firstWhereOrNull((element) => element.orderId == widget.partyId);
      partyNameController.text = partyData?.partyName ?? "";
      contactNumberController.text = partyData?.contactNumber ?? "";
      paymentType.value = partyData?.paymentType ?? "";
      pendingBalanceController.text = partyData?.pendingBalance?.toString() ?? "0.0";
      referenceNameController.text = partyData?.referenceName ?? "";
      referenceNumberController.text = partyData?.referenceNumber ?? "";
    }
  }

  String? validatePartyList(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterPartyName.tr;
    }
    return null;
  }

  String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterContactNumber.tr;
    } else if (value.length < 10) {
      return AppStrings.pleaseEnterValidPhoneNumber.tr;
    }
    return null;
  }

  String? validateReferenceNumber(String? value) {
    if (value != null && value.isNotEmpty && value.length < 10) {
      return AppStrings.pleaseEnterValidReferenceNumber.tr;
    }
    return null;
  }

  String? validatePendingBalance(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterPendingBalance.tr;
    } else if ((value.toTryDouble() ?? 0.0) < 0.0) {
      return AppStrings.pleaseEnterValidAmount.tr;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
    return UnfocusWidget(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: keyboardPadding != 0 ? keyboardPadding : 2.h),
          child: Form(
            key: addEditFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///Close, Title & Select
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CloseButtonWidget(),
                      SizedBox(width: 2.w),
                      Flexible(
                        child: Text(
                          widget.partyId != null ? AppStrings.editPartyDetails.tr : AppStrings.addParty.tr,
                          textAlign: TextAlign.center,
                          style: AppStyles.size18w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      IconButton(
                        onPressed: () async {
                          if (isSaving.isTrue) return;
                          try {
                            isSaving(true);
                            if (addEditFormKey.currentState?.validate() ?? false) {
                              if (paymentType.isEmpty) {
                                Utils.handleMessage(message: AppStrings.pleaseSelectPaymentType.tr, isError: true);
                                return;
                              }
                              ResponseModel response;
                              if (widget.partyId == null) {
                                response = await widget.controller.createPartyApiCall(
                                  partyName: partyNameController.text.trim(),
                                  contactNumber: contactNumberController.text.trim(),
                                  pendingBalance: pendingBalanceController.text.trim(),
                                  paymentType: paymentType.value,
                                  referenceName: referenceNameController.text.trim(),
                                  referenceNumber: referenceNumberController.text.trim(),
                                );
                              } else {
                                response = await widget.controller.editPartyApiCall(
                                  orderId: widget.partyId ?? "",
                                  partyName: partyNameController.text.trim(),
                                  contactNumber: contactNumberController.text.trim(),
                                  pendingBalance: pendingBalanceController.text.trim(),
                                  paymentType: paymentType.value,
                                  referenceName: referenceNameController.text.trim(),
                                  referenceNumber: referenceNumberController.text.trim(),
                                );
                              }
                              if (response.isSuccess) {
                                await widget.controller.getPartyApiCall(isRefresh: true);
                                Get.back(closeOverlays: true);
                                Utils.handleMessage(message: response.message);
                              }
                            }
                          } finally {
                            isSaving(false);
                          }
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.DARK_GREEN_COLOR,
                          maximumSize: Size.square(8.w),
                          minimumSize: Size.square(8.w),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: Obx(() {
                          if (isSaving.isTrue) {
                            return SizedBox.square(
                              dimension: 3.5.w,
                              child: CircularProgressIndicator(
                                color: AppColors.PRIMARY_COLOR,
                                strokeWidth: 1.5,
                              ),
                            );
                          } else {
                            return Icon(
                              Icons.check_rounded,
                              color: AppColors.PRIMARY_COLOR,
                              size: 5.w,
                            );
                          }
                        }),
                      ),
                    ],
                  ),
                ),
                DividerWidget(),
                SizedBox(height: 2.h),

                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      children: [
                        ///Party Name
                        TextFieldWidget(
                          controller: partyNameController,
                          title: AppStrings.partyName.tr,
                          hintText: AppStrings.enterPartyName.tr,
                          validator: validatePartyList,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 2.h),

                        ///Contact Number
                        TextFieldWidget(
                          controller: contactNumberController,
                          title: AppStrings.contactNumber.tr,
                          hintText: AppStrings.enterContactNumber.tr,
                          validator: validateContactNumber,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            TextInputFormatter.withFunction((oldValue, newValue) {
                              if (!newValue.text.isNumericOnly && newValue.text.isNotEmpty) {
                                return oldValue;
                              } else {
                                return newValue;
                              }
                            }),
                          ],
                          maxLength: 10,
                        ),
                        SizedBox(height: 2.h),

                        ///Pending Balance
                        TextFieldWidget(
                          controller: pendingBalanceController,
                          title: AppStrings.pendingBalance.tr,
                          hintText: AppStrings.enterAmount.tr,
                          validator: validatePendingBalance,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            TextInputFormatter.withFunction((oldValue, newValue) {
                              if ((!newValue.text.isNum || (newValue.text.toTryDouble() ?? 0.0) < 0.0) && newValue.text.isNotEmpty) {
                                return oldValue;
                              } else {
                                return newValue;
                              }
                            }),
                          ],
                          maxLength: 10,
                        ),
                        SizedBox(height: 2.h),

                        ///Reference Name
                        TextFieldWidget(
                          controller: referenceNameController,
                          title: AppStrings.referenceName.tr,
                          hintText: AppStrings.enterReferenceName.tr,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 2.h),

                        ///Reference Number
                        TextFieldWidget(
                          controller: referenceNumberController,
                          title: AppStrings.referenceNumber.tr,
                          hintText: AppStrings.enterReferenceNumber.tr,
                          validator: validateReferenceNumber,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            TextInputFormatter.withFunction((oldValue, newValue) {
                              if (!newValue.text.isNumericOnly && newValue.text.isNotEmpty) {
                                return oldValue;
                              } else {
                                return newValue;
                              }
                            }),
                          ],
                          maxLength: 10,
                        ),
                        SizedBox(height: 2.h),

                        ///Payment Type
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppStrings.paymentOptions.tr,
                              style: AppStyles.size16w600,
                            ),
                          ),
                        ),
                        DividerWidget(),
                        SizedBox(height: 0.7.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///Cash
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  paymentType(ApiKeys.cash);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      return AnimatedContainer(
                                        duration: 375.milliseconds,
                                        padding: EdgeInsets.all(0.7.w),
                                        decoration: BoxDecoration(
                                          color: paymentType.value == ApiKeys.cash ? AppColors.PRIMARY_COLOR : AppColors.SECONDARY_COLOR,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.PRIMARY_COLOR,
                                            width: 1.2,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.check_rounded,
                                          color: AppColors.SECONDARY_COLOR,
                                          size: 4.w,
                                        ),
                                      );
                                    }),
                                    SizedBox(width: 2.w),
                                    Text(
                                      AppStrings.cash.tr,
                                      style: AppStyles.size16w600,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),

                            ///GST (18%)
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  paymentType(ApiKeys.gst18);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      return AnimatedContainer(
                                        duration: 375.milliseconds,
                                        padding: EdgeInsets.all(0.7.w),
                                        decoration: BoxDecoration(
                                          color: paymentType.value == ApiKeys.gst18 ? AppColors.PRIMARY_COLOR : AppColors.SECONDARY_COLOR,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.PRIMARY_COLOR,
                                            width: 1.2,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.check_rounded,
                                          color: AppColors.SECONDARY_COLOR,
                                          size: 4.w,
                                        ),
                                      );
                                    }),
                                    SizedBox(width: 2.w),
                                    Text(
                                      AppStrings.gst18.tr,
                                      style: AppStyles.size16w600,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///Without
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  paymentType(ApiKeys.without);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      return AnimatedContainer(
                                        duration: 375.milliseconds,
                                        padding: EdgeInsets.all(0.7.w),
                                        decoration: BoxDecoration(
                                          color: paymentType.value == ApiKeys.without ? AppColors.PRIMARY_COLOR : AppColors.SECONDARY_COLOR,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.PRIMARY_COLOR,
                                            width: 1.2,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.check_rounded,
                                          color: AppColors.SECONDARY_COLOR,
                                          size: 4.w,
                                        ),
                                      );
                                    }),
                                    SizedBox(width: 2.w),
                                    Text(
                                      AppStrings.without.tr,
                                      style: AppStyles.size16w600,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),

                            ///GST (9%)
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  paymentType(ApiKeys.gst9);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      return AnimatedContainer(
                                        duration: 375.milliseconds,
                                        padding: EdgeInsets.all(0.7.w),
                                        decoration: BoxDecoration(
                                          color: paymentType.value == ApiKeys.gst9 ? AppColors.PRIMARY_COLOR : AppColors.SECONDARY_COLOR,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.PRIMARY_COLOR,
                                            width: 1.2,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.check_rounded,
                                          color: AppColors.SECONDARY_COLOR,
                                          size: 4.w,
                                        ),
                                      );
                                    }),
                                    SizedBox(width: 2.w),
                                    Text(
                                      AppStrings.gst9.tr,
                                      style: AppStyles.size16w600,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
