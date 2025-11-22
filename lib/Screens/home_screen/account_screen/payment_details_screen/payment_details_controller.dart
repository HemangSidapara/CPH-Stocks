import 'package:cached_network_image/cached_network_image.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/app_validators.dart';
import 'package:cph_stocks/Network/models/account_models/get_all_payments_model.dart' as get_all_payments;
import 'package:cph_stocks/Network/models/account_models/get_party_payment_model.dart' as get_payments;
import 'package:cph_stocks/Network/models/order_models/get_parties_model.dart' as get_parties;
import 'package:cph_stocks/Network/services/account_services/account_services.dart';
import 'package:cph_stocks/Network/services/order_services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentDetailsController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxInt tabIndex = 0.obs;

  RxBool isLoading = false.obs;

  RxList<get_parties.Data> partyList = <get_parties.Data>[].obs;
  RxString selectedParty = "".obs;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController partyNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController paymentModeController = TextEditingController();
  RxString base64Image = "".obs;
  RxInt selectedPaymentMode = 0.obs;

  RxList<get_payments.PartyPaymentData> paymentList = RxList();
  RxList<get_payments.PartyPaymentData> filteredPaymentList = RxList();

  RxBool isPaymentAddEnable = false.obs;
  RxBool isPaymentAdding = false.obs;

  List<String> paymentModeList = [
    AppStrings.cash,
    AppStrings.online,
    AppStrings.onlinePatel,
    AppStrings.onlineKevin,
    AppStrings.billGST,
  ];

  TextEditingController paymentDateController = TextEditingController(text: DateFormat("dd/MM/yyyy").format(DateTime.now()));

  RxBool isPaymentsLoading = false.obs;
  RxList<get_all_payments.PartyPaymentData> allPaymentsList = RxList();
  RxList<get_all_payments.PartyPaymentData> filteredAllPaymentsList = RxList();
  Rx<DateTimeRange<DateTime>?> filterDateRange = Rx(null);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      tabIndex(tabController.index);
    });
    getPartiesApi();
    getAllPaymentsApiCall();
  }

  String? validatePartyName(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseSelectParty.tr;
    }
    return null;
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseEnterAmount.tr;
    } else if (!AppValidators.doubleValidator.hasMatch(value)) {
      return AppStrings.pleaseEnterValidaAmount.tr;
    }
    return null;
  }

  String? validateDiscount(String? value) {
    if (value != null && value.isNotEmpty && !AppValidators.doubleValidator.hasMatch(value)) {
      return AppStrings.pleaseEnterValidDiscount.tr;
    }
    return null;
  }

  String? validatePaymentMode(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseSelectPaymentMode.tr;
    }
    return null;
  }

  String? validatePaymentDate(String? value) {
    if (value == null || value.isEmpty == true) {
      return AppStrings.pleaseSelectDate.tr;
    }
    return null;
  }

  Future<RxList<get_parties.Data>> getPartiesApi() async {
    final response = await OrderServices.getPartiesService();
    if (response.isSuccess) {
      get_parties.GetPartiesModel getPartiesModel = get_parties.GetPartiesModel.fromJson(response.response?.data);
      partyList.clear();
      partyList.addAll(getPartiesModel.data ?? []);
    }
    return partyList;
  }

  Future<void> getAllPaymentsApiCall({bool isRefresh = false}) async {
    try {
      isPaymentsLoading(!isRefresh);
      final response = await AccountServices.getAllPaymentsService();

      if (response.isSuccess) {
        get_all_payments.GetAllPaymentsModel getAllPaymentsModel = get_all_payments.GetAllPaymentsModel.fromJson(response.response?.data ?? {});
        allPaymentsList.clear();
        filteredAllPaymentsList.clear();
        allPaymentsList.addAll(getAllPaymentsModel.data ?? []);
        filterAllPayments();
      }
    } finally {
      isPaymentsLoading(false);
    }
  }

  void filterAllPayments() {
    filteredAllPaymentsList.clear();
    if (filterDateRange.value != null) {
      filteredAllPaymentsList.addAll(
        allPaymentsList.where((element) {
          if (element.createdDate == null || element.createdDate?.isEmpty == true) {
            return false;
          }
          final paymentDate = DateTime.parse(element.createdDate!);
          return (paymentDate.isAfter(filterDateRange.value!.start) && paymentDate.isBefore(filterDateRange.value!.end)) || paymentDate.isAtSameMomentAs(filterDateRange.value!.start) || paymentDate.isAtSameMomentAs(filterDateRange.value!.end);
        }).toList(),
      );
    } else {
      filteredAllPaymentsList.addAll([...allPaymentsList]);
    }
  }

  Future<void> getPartyPaymentApiCall({
    bool isRefresh = false,
  }) async {
    try {
      isLoading(!isRefresh);
      if (formKey.currentState?.validate() ?? false) {
        final response = await AccountServices.getPartyPaymentService(partyId: selectedParty.value);

        if (response.isSuccess) {
          get_payments.GetPartyPaymentModel partyPaymentModel = get_payments.GetPartyPaymentModel.fromJson(response.response?.data);
          paymentList.clear();
          filteredPaymentList.clear();
          paymentList.addAll(partyPaymentModel.data ?? []);
          filteredPaymentList.addAll(partyPaymentModel.data ?? []);
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> deletePaymentApiCall({String? partyPaymentMetaId}) async {
    final response = await AccountServices.deletePartyPaymentService(
      partyPaymentMetaId: partyPaymentMetaId ?? "",
    );

    if (response.isSuccess) {
      Utils.handleMessage(message: response.message);
      getPartyPaymentApiCall(isRefresh: true);
      getAllPaymentsApiCall(isRefresh: true);
    }
  }

  Future<void> createPaymentApiCall() async {
    try {
      isPaymentAdding(true);
      if (formKey.currentState?.validate() ?? false) {
        final response = await AccountServices.createPartyPaymentService(
          partyId: selectedParty.value,
          amount: amountController.text.trim(),
          discount: discountController.text.trim(),
          paymentImage: base64Image.value,
          paymentMode: paymentModeList[selectedPaymentMode.value],
          paymentDate: paymentDateController.text.trim().isNotEmpty ? DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy").parse(paymentDateController.text.trim())) : DateFormat("yyyy-MM-dd").format(DateTime.now()),
        );

        if (response.isSuccess) {
          await getPartyPaymentApiCall(isRefresh: filteredPaymentList.isNotEmpty);
          Utils.handleMessage(message: response.message);
        }
      }
    } finally {
      isPaymentAdding(false);
    }
  }

  Future<void> editPaymentApiCall({
    required String partyPaymentMetaId,
    required String amount,
    required String discount,
    required String paymentMode,
    required String paymentDate,
    required String paymentImage,
  }) async {
    final response = await AccountServices.editPartyPaymentService(
      partyPaymentMetaId: partyPaymentMetaId,
      amount: amount,
      discount: discount,
      paymentMode: paymentMode,
      paymentDate: paymentDate,
      paymentImage: paymentImage,
    );

    if (response.isSuccess) {
      Get.back();
      await getPartyPaymentApiCall(isRefresh: true);
      Utils.handleMessage(message: response.message);
    }
  }

  Future<void> showItemImageDialog({
    required String itemName,
    required String itemImage,
  }) async {
    await showGeneralDialog(
      context: Get.context!,
      barrierDismissible: false,
      barrierColor: AppColors.SECONDARY_COLOR,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Material(
            color: AppColors.SECONDARY_COLOR,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
              child: Column(
                children: [
                  ///ItemName
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            itemName,
                            style: TextStyle(
                              color: AppColors.PRIMARY_COLOR,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: IconButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                          ),
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppColors.PRIMARY_COLOR,
                            size: 7.w,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///Item Image
                  Center(
                    child: SizedBox(
                      height: 80.h,
                      child: InteractiveViewer(
                        maxScale: 5.0,
                        child: CachedNetworkImage(
                          imageUrl: itemImage,
                          fit: BoxFit.contain,
                          cacheKey: itemImage,
                          progressIndicatorBuilder: (context, url, progress) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.SECONDARY_COLOR,
                                value: progress.progress,
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorWidget: (context, error, stackTrace) {
                            return SizedBox(
                              height: 15.h,
                              width: double.maxFinite,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_rounded,
                                    size: 6.w,
                                    color: AppColors.ERROR_COLOR,
                                  ),
                                  Text(
                                    error.toString().replaceAll('Exception: ', ''),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.SECONDARY_COLOR,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
