import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:cph_stocks/Screens/home_screen/cash_flow_scren/cash_flow_controller.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_view.dart';
import 'package:cph_stocks/Widgets/close_button_widget.dart';
import 'package:cph_stocks/Widgets/divider_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddEditCashFlowWidget extends StatefulWidget {
  final String? cashFlowId;
  final CashFlowController controller;

  const AddEditCashFlowWidget({
    super.key,
    this.cashFlowId,
    required this.controller,
  });

  @override
  State<AddEditCashFlowWidget> createState() => _AddEditCashFlowWidgetState();
}

class _AddEditCashFlowWidgetState extends State<AddEditCashFlowWidget> {
  GlobalKey<FormState> addEditFormKey = GlobalKey<FormState>();

  RxBool isCashIn = false.obs;
  TextEditingController noteController = TextEditingController();
  List<String> paymentModeList = [
    "CASH",
    "BANK",
    "UPI",
    "CHEQUE",
    "OTHER",
  ];
  TextEditingController modeOfPaymentController = TextEditingController();
  int selectedPaymentMode = -1;
  TextEditingController amountController = TextEditingController();

  RxBool isSaving = false.obs;

  @override
  void initState() {
    super.initState();
    final cashObject = widget.controller.cashFlowList.firstWhereOrNull((element) => element.cashFlowId == widget.cashFlowId);
    if (cashObject != null) {
      isCashIn.value = cashObject.cashType == "IN";
      noteController.text = cashObject.note ?? "";
      modeOfPaymentController.text = cashObject.modeOfPayment ?? "";
      amountController.text = cashObject.amount ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
    return UnfocusWidget(
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboardPadding != 0 ? keyboardPadding : 2.h),
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
                      widget.cashFlowId != null ? AppStrings.editCashFlow.tr : AppStrings.addCashFlow.tr,
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
                          ResponseModel response;
                          if (widget.cashFlowId == null) {
                            response = await widget.controller.addCashFlowApiCall(
                              cashType: isCashIn.isTrue ? "IN" : "OUT",
                              note: noteController.text.trim(),
                              modeOfPayment: modeOfPaymentController.text,
                              amount: amountController.text,
                            );
                          } else {
                            response = await widget.controller.editCashFlowApiCall(
                              cashFlowId: widget.cashFlowId ?? "",
                              cashType: isCashIn.isTrue ? "IN" : "OUT",
                              note: noteController.text.trim(),
                              modeOfPayment: modeOfPaymentController.text,
                              amount: amountController.text,
                            );
                          }
                          if (response.isSuccess) {
                            await widget.controller.getCashFlowApiCall(isRefresh: true);
                            Get.back();
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
              child: Form(
                key: addEditFormKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///Cash Type
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppStrings.cashType.tr,
                          style: AppStyles.size16w600,
                        ),
                      ),
                      DividerWidget(),
                      SizedBox(height: 0.7.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///Cash In
                          GestureDetector(
                            onTap: () {
                              isCashIn(true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() {
                                  return AnimatedContainer(
                                    duration: 375.milliseconds,
                                    padding: EdgeInsets.all(0.7.w),
                                    decoration: BoxDecoration(
                                      color: isCashIn.isTrue ? AppColors.PRIMARY_COLOR : AppColors.SECONDARY_COLOR,
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
                                  AppStrings.inFlow.tr,
                                  style: AppStyles.size16w600,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),

                          ///Cash Out
                          GestureDetector(
                            onTap: () {
                              isCashIn(false);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() {
                                  return AnimatedContainer(
                                    duration: 375.milliseconds,
                                    padding: EdgeInsets.all(0.7.w),
                                    decoration: BoxDecoration(
                                      color: isCashIn.isTrue ? AppColors.SECONDARY_COLOR : AppColors.PRIMARY_COLOR,
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
                                  AppStrings.outFlow.tr,
                                  style: AppStyles.size16w600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      SizedBox(height: 1.h),

                      ///Notes
                      TextFieldWidget(
                        controller: noteController,
                        title: AppStrings.notes.tr,
                        hintText: AppStrings.enterNotes.tr,
                        maxLength: 200,
                        minLines: 3,
                        maxLines: 5,
                      ),
                      SizedBox(height: 2.h),

                      ///Mode of Payment
                      TextFieldWidget(
                        controller: modeOfPaymentController,
                        title: AppStrings.paymentMode.tr,
                        hintText: AppStrings.selectPaymentMode.tr,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.pleaseSelectPaymentMode.tr;
                          }
                          return null;
                        },
                        onTap: () {
                          CreateOrderView().showBottomSheetSelectAndAdd(
                            ctx: context,
                            selectOnly: true,
                            items: paymentModeList,
                            title: AppStrings.paymentMode.tr,
                            fieldHint: "",
                            searchHint: AppStrings.searchPaymentMode.tr,
                            selectedId: selectedPaymentMode,
                            controller: modeOfPaymentController,
                            onSelect: (id) {
                              selectedPaymentMode = id;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 2.h),

                      ///Amount
                      TextFieldWidget(
                        controller: amountController,
                        title: AppStrings.amount.tr,
                        hintText: AppStrings.enterAmount.tr,
                        maxLength: 8,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.pleaseEnterAmount.tr;
                          } else if (!value.isNum) {
                            return AppStrings.pleaseEnterValidaAmount.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
