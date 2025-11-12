import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/response_model.dart';
import 'package:cph_stocks/Screens/home_screen/account_screen/ledger_screen/ledger_view.dart';
import 'package:cph_stocks/Screens/home_screen/cash_flow_scren/cash_flow_controller.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_view.dart';
import 'package:cph_stocks/Widgets/close_button_widget.dart';
import 'package:cph_stocks/Widgets/divider_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddEditCashFlowWidget extends StatefulWidget {
  final String? cashFlowId;
  final CashFlowController controller;
  final bool isOut;

  const AddEditCashFlowWidget({
    super.key,
    this.cashFlowId,
    required this.controller,
    this.isOut = false,
  });

  @override
  State<AddEditCashFlowWidget> createState() => _AddEditCashFlowWidgetState();
}

class _AddEditCashFlowWidgetState extends State<AddEditCashFlowWidget> {
  GlobalKey<FormState> addEditFormKey = GlobalKey<FormState>();

  RxBool isCashIn = false.obs;
  TextEditingController noteController = TextEditingController();
  List<String> paymentModeList = [
    AppStrings.cash,
    AppStrings.online,
    AppStrings.onlinePatel,
    AppStrings.onlineKevin,
    AppStrings.billGST,
  ];
  TextEditingController modeOfPaymentController = TextEditingController();
  int selectedPaymentMode = -1;
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  RxBool isSaving = false.obs;

  String formatedDate(String? date) => date != null ? DateFormat("dd/MM/yyyy").format(DateTime.parse(date)) : "";

  @override
  void initState() {
    super.initState();
    final cashObject = (widget.controller.tabIndex.value == 0 ? widget.controller.cashCashFlowList : widget.controller.onlineCashFlowList).firstWhereOrNull((element) => element.cashFlowId == widget.cashFlowId);
    if (cashObject != null) {
      isCashIn.value = cashObject.cashType == "IN";
      noteController.text = cashObject.note ?? "";
      modeOfPaymentController.text = cashObject.modeOfPayment ?? "";
      selectedPaymentMode = paymentModeList.indexOf(cashObject.modeOfPayment ?? "");
      amountController.text = cashObject.amount ?? "";
      dateController.text = formatedDate(cashObject.createdDate);
    } else {
      isCashIn.value = !widget.isOut;
      selectedPaymentMode = widget.controller.tabIndex.value == 0 ? 0 : 3;
      modeOfPaymentController.text = paymentModeList[selectedPaymentMode];
      dateController.text = formatedDate(DateTime.now().toString());
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
                              modeOfPayment: paymentModeList[selectedPaymentMode],
                              amount: amountController.text,
                              createdDate: DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy").parse(dateController.text.trim())),
                            );
                          } else {
                            response = await widget.controller.editCashFlowApiCall(
                              cashFlowId: widget.cashFlowId ?? "",
                              cashType: isCashIn.isTrue ? "IN" : "OUT",
                              note: noteController.text.trim(),
                              modeOfPayment: paymentModeList[selectedPaymentMode],
                              amount: amountController.text,
                              createdDate: DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy").parse(dateController.text.trim())),
                            );
                          }
                          if (response.isSuccess) {
                            await widget.controller.getCashFlowApiCall(isRefresh: true);
                            if (selectedPaymentMode == 0 && widget.controller.tabIndex.value != 0) {
                              widget.controller.tabController.animateTo(0);
                            } else if (selectedPaymentMode != 0 && widget.controller.tabIndex.value == 0) {
                              widget.controller.tabController.animateTo(1);
                            }
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

                      ///Date
                      TextFieldWidget(
                        controller: dateController,
                        title: AppStrings.date.tr,
                        hintText: AppStrings.selectDate.tr,
                        readOnly: true,
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: dateController.text.trim().isNotEmpty ? DateFormat("dd/MM/yyyy").parse(dateController.text.trim()) : DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 50),
                            lastDate: DateTime(DateTime.now().year + 50),
                            builder: (context, child) {
                              return LedgerView().themeData(context: context, child: child!);
                            },
                          ).then((value) {
                            if (value != null) {
                              dateController.text = DateFormat("dd/MM/yyyy").format(value);
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.pleaseSelectDate.tr;
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
