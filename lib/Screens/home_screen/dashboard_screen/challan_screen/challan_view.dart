import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/app_validators.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/models/challan_models/get_invoices_model.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/challan_screen/challan_controller.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/challan_screen/invoice_view.dart';
import 'package:cph_stocks/Screens/home_screen/dashboard_screen/create_order_screen/create_order_view.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/close_button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/divider_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/no_data_found_widget.dart';
import 'package:cph_stocks/Widgets/show_bottom_sheet_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChallanView extends GetView<ChallanController> {
  const ChallanView({super.key});

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Obx(() {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: controller.deletingInvoicesEnable.isTrue ? AppColors.DARK_RED_COLOR : AppColors.TRANSPARENT,
            leadingWidth: 0,
            leading: SizedBox.shrink(),
            actionsPadding: EdgeInsets.zero,
            flexibleSpace: SafeArea(
              child: controller.deletingInvoicesEnable.isTrue
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 0.6.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.deletingInvoicesEnable(false);
                                  controller.selectedInvoices.clear();
                                },
                                style: IconButton.styleFrom(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                ),
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: AppColors.WHITE_COLOR,
                                  size: context.isPortrait ? 7.w : 7.h,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                AppStrings.selectChallan.tr,
                                style: TextStyle(
                                  color: AppColors.WHITE_COLOR,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Obx(() {
                            return IconButton(
                              onPressed: controller.isDeleteInvoicesLoading.isFalse
                                  ? () async {
                                      if (controller.selectedInvoices.isNotEmpty) {
                                        try {
                                          controller.isDeleteInvoicesLoading(true);
                                          await controller.showDeleteDialog(
                                            onPressed: () async {
                                              await controller.deleteInvoicesApiCall();
                                            },
                                            title: AppStrings.deleteChallanText.tr,
                                          );
                                        } finally {
                                          controller.isDeleteInvoicesLoading(false);
                                          controller.deletingInvoicesEnable(false);
                                          controller.selectedInvoices.clear();
                                        }
                                      } else {
                                        Utils.handleMessage(message: AppStrings.pleaseSelectAtLeastOneChallan.tr, isError: true);
                                      }
                                    }
                                  : () {},
                              style: IconButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.zero,
                              ),
                              icon: controller.isDeleteInvoicesLoading.isTrue
                                  ? SizedBox(
                                      width: context.isPortrait ? 5.w : 5.h,
                                      height: context.isPortrait ? 5.w : 5.h,
                                      child: CircularProgressIndicator(
                                        color: AppColors.WHITE_COLOR,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Icon(
                                      Icons.delete_forever_rounded,
                                      color: AppColors.WHITE_COLOR,
                                      size: context.isPortrait ? 6.w : 6.h,
                                    ),
                            );
                          }),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomHeaderWidget(
                            title: AppStrings.challan.tr,
                            titleIcon: AppAssets.challanIcon,
                            onBackPressed: () {
                              Get.back(closeOverlays: true);
                            },
                          ),
                          Obx(() {
                            return IconButton(
                              onPressed: controller.isRefreshing.value
                                  ? () {}
                                  : () async {
                                      await controller.getInvoicesApi(isLoading: false);
                                    },
                              style: IconButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.zero,
                              ),
                              icon: Obx(() {
                                return TweenAnimationBuilder(
                                  duration: Duration(seconds: controller.isRefreshing.value ? 45 : 1),
                                  tween: Tween(begin: 0.0, end: controller.isRefreshing.value ? 45.0 : controller.ceilValueForRefresh.value),
                                  onEnd: () {
                                    controller.isRefreshing.value = false;
                                  },
                                  builder: (context, value, child) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      controller.ceilValueForRefresh(value.toDouble().ceilToDouble());
                                    });
                                    return Transform.rotate(
                                      angle: value * 2 * 3.141592653589793,
                                      child: Icon(
                                        Icons.refresh_rounded,
                                        color: AppColors.PRIMARY_COLOR,
                                        size: context.isPortrait ? 6.w : 6.h,
                                      ),
                                    );
                                  },
                                );
                              }),
                            );
                          }),
                        ],
                      ),
                    ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.5.h),
              child: Column(
                children: [
                  ///Searchbar
                  if (controller.deletingInvoicesEnable.isFalse) ...[
                    TextFieldWidget(
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColors.SECONDARY_COLOR,
                        size: 5.w,
                      ),
                      prefixIconConstraints: BoxConstraints(maxHeight: 5.h, maxWidth: 8.w, minWidth: 8.w),
                      suffixIcon: InkWell(
                        onTap: () {
                          Utils.unfocus();
                          controller.searchController.clear();
                          controller.searchPartyName("");
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: AppColors.SECONDARY_COLOR,
                          size: 5.w,
                        ),
                      ),
                      suffixIconConstraints: BoxConstraints(maxHeight: 5.h, maxWidth: 12.w, minWidth: 12.w),
                      hintText: AppStrings.searchParty.tr,
                      controller: controller.searchController,
                      onChanged: (value) {
                        controller.searchPartyName(value);
                      },
                    ),
                    SizedBox(height: 2.h),
                  ],

                  ///Invoices
                  Expanded(
                    child: Obx(() {
                      if (controller.isGetInvoicesLoading.isTrue) {
                        return const Center(
                          child: LoadingWidget(),
                        );
                      } else if (controller.searchedInvoiceList.isEmpty) {
                        return NoDataFoundWidget(
                          subtitle: AppStrings.noDataFound.tr,
                          onPressed: () {
                            controller.getInvoicesApi(isLoading: false);
                          },
                        );
                      } else {
                        return ListView.separated(
                          itemCount: controller.searchedInvoiceList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final orderInvoice = controller.searchedInvoiceList[index];
                            return GestureDetector(
                              onTap: controller.deletingInvoicesEnable.isTrue
                                  ? () {
                                      if (controller.selectedInvoices.contains(orderInvoice.orderInvoiceId)) {
                                        controller.selectedInvoices.removeWhere((element) => element == orderInvoice.orderInvoiceId);
                                      } else {
                                        controller.selectedInvoices.add(orderInvoice.orderInvoiceId ?? "");
                                      }
                                    }
                                  : null,
                              onLongPress: getData(AppConstance.role) != AppConstance.customer && controller.deletingInvoicesEnable.isFalse
                                  ? () {
                                      controller.deletingInvoicesEnable(true);
                                      controller.selectedInvoices.add(orderInvoice.orderInvoiceId ?? "");
                                    }
                                  : null,
                              behavior: HitTestBehavior.opaque,
                              child: Card(
                                color: AppColors.TRANSPARENT,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ExpansionTile(
                                  enabled: controller.deletingInvoicesEnable.isFalse,
                                  title: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${orderInvoice.challanNumber ?? ''}. ",
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.DARK_RED_COLOR,
                                              ),
                                            ),
                                            SizedBox(width: 2.w),
                                            Expanded(
                                              child: Text(
                                                controller.searchedInvoiceList[index].partyName ?? '',
                                                style: TextStyle(
                                                  color: AppColors.SECONDARY_COLOR,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          if (controller.deletingInvoicesEnable.isFalse) ...[
                                            ///Edit Invoice
                                            ElevatedButton(
                                              onPressed: () {
                                                if (orderInvoice.invoiceMeta?.isNotEmpty == true) {
                                                  showBottomSheetRowList(
                                                    ctx: context,
                                                    data: orderInvoice.invoiceMeta ?? [],
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.WARNING_COLOR,
                                                shape: CircleBorder(),
                                                minimumSize: Size.square(8.w),
                                                maximumSize: Size.square(8.w),
                                                padding: EdgeInsets.zero,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              ),
                                              child: Icon(
                                                Icons.edit_rounded,
                                                size: 5.w,
                                                color: AppColors.PRIMARY_COLOR,
                                              ),
                                            ),
                                            SizedBox(width: 2.w),

                                            ///View Invoice
                                            ElevatedButton(
                                              onPressed: () {
                                                showInvoiceBottomSheet(
                                                  ctx: context,
                                                  partyName: orderInvoice.partyName ?? '',
                                                  challanNumber: orderInvoice.challanNumber ?? '',
                                                  createdDate: orderInvoice.createdDate ?? '',
                                                  invoiceData: orderInvoice.invoiceMeta ?? [],
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.ORANGE_COLOR,
                                                shape: CircleBorder(),
                                                minimumSize: Size.square(8.w),
                                                maximumSize: Size.square(8.w),
                                                padding: EdgeInsets.zero,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              ),
                                              child: Icon(
                                                Icons.visibility_rounded,
                                                size: 5.w,
                                                color: AppColors.PRIMARY_COLOR,
                                              ),
                                            ),
                                          ] else ...[
                                            Obx(() {
                                              return AnimatedContainer(
                                                duration: const Duration(milliseconds: 375),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: controller.selectedInvoices.contains(orderInvoice.orderInvoiceId) ? AppColors.DARK_RED_COLOR : AppColors.SECONDARY_COLOR,
                                                    width: 1,
                                                  ),
                                                  color: controller.selectedInvoices.contains(orderInvoice.orderInvoiceId) ? AppColors.DARK_RED_COLOR : AppColors.TRANSPARENT,
                                                ),
                                                padding: EdgeInsets.all(context.isPhone ? 1.w : 1.h),
                                                child: AnimatedOpacity(
                                                  duration: const Duration(milliseconds: 375),
                                                  opacity: controller.selectedInvoices.contains(orderInvoice.orderInvoiceId) ? 1 : 0,
                                                  child: Icon(
                                                    Icons.done_rounded,
                                                    size: 3.5.w,
                                                    color: AppColors.WHITE_COLOR,
                                                  ),
                                                ),
                                              );
                                            }),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                  dense: true,
                                  collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                                  backgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                                  iconColor: AppColors.SECONDARY_COLOR,
                                  collapsedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  childrenPadding: EdgeInsets.only(bottom: 2.h),
                                  tilePadding: EdgeInsets.symmetric(horizontal: 3.w),
                                  showTrailingIcon: false,
                                  children: [
                                    Divider(
                                      color: AppColors.HINT_GREY_COLOR,
                                      thickness: 1,
                                    ),
                                    SizedBox(height: 1.h),

                                    ///Created At
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${AppStrings.createdAt.tr}: ",
                                            style: AppStyles.size15w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                          ),
                                          Text(
                                            "${orderInvoice.createdDate != null ? DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd").parse(orderInvoice.createdDate!)) : ""}, ${DateFormat("hh:mm a").format(DateFormat("hh:mm:ss").parse(orderInvoice.createdTime!))}".trim(),
                                            style: AppStyles.size15w600.copyWith(color: AppColors.SECONDARY_COLOR),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 2.h);
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> showBottomSheetRowList({
    required BuildContext ctx,
    required List<InvoiceMeta> data,
  }) async {
    await showBottomSheetWidget(
      context: ctx,
      builder: (context) {
        return SafeArea(
          child: Column(
            children: [
              ///Back & Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(right: 2.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Title
                    Text(
                      AppStrings.selectRow.tr,
                      style: TextStyle(
                        color: AppColors.PRIMARY_COLOR,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),

                    ///Back
                    CloseButtonWidget(),
                  ],
                ),
              ),
              DividerWidget(color: AppColors.HINT_GREY_COLOR),
              SizedBox(height: 1.h),

              ///Row List
              Expanded(
                child: ListView.separated(
                  itemCount: data.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.5.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index].inDate != null ? DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-dd").parse(data[index].inDate!)) : "",
                                  style: AppStyles.size16w600.copyWith(color: AppColors.PRIMARY_COLOR),
                                ),
                                Text(
                                  data[index].itemName ?? "",
                                  style: AppStyles.size16w600.copyWith(color: AppColors.PRIMARY_COLOR),
                                ),
                                Text(
                                  "${data[index].categoryName ?? ""}: ${NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(data[index].categoryPrice?.toDouble() ?? 0.0)}",
                                  style: AppStyles.size16w600.copyWith(color: AppColors.PRIMARY_COLOR),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),

                          ///Edit Row
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                              showBottomSheetEditRow(
                                ctx: context,
                                data: data[index],
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.WARNING_COLOR,
                              shape: CircleBorder(),
                              minimumSize: Size.square(8.w),
                              maximumSize: Size.square(8.w),
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Icon(
                              Icons.edit_rounded,
                              size: 5.w,
                              color: AppColors.PRIMARY_COLOR,
                            ),
                          ),
                          SizedBox(width: 2.w),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return DividerWidget(color: AppColors.HINT_GREY_COLOR);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showBottomSheetEditRow({
    required BuildContext ctx,
    required InvoiceMeta data,
  }) async {
    RxBool isLoading = false.obs;

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    TextEditingController categoryNameController = TextEditingController(text: data.categoryName);
    String selectedCategoryId = data.categoryId ?? "";
    TextEditingController itemNameController = TextEditingController(text: data.itemName);
    TextEditingController inchController = TextEditingController(text: data.inch);

    String? validateCategoryName(String? value) {
      if (value == null || value.isEmpty == true) {
        return AppStrings.pleaseSelectCategoryName.tr;
      }
      return null;
    }

    String? validateSize(String? value) {
      if (value == null || value.isEmpty == true) {
        return AppStrings.pleaseEnterSize.tr;
      } else if (!AppValidators.doubleValidator.hasMatch(value)) {
        return AppStrings.pleaseEnterValidSize.tr;
      }
      return null;
    }

    await showBottomSheetWidget(
      context: ctx,
      builder: (context) {
        final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: keyboardPadding),
            child: Column(
              children: [
                ///Back & Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(right: 2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///Title
                      Text(
                        AppStrings.editRow.tr,
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.sp,
                        ),
                      ),

                      ///Back
                      CloseButtonWidget(),
                    ],
                  ),
                ),
                DividerWidget(color: AppColors.HINT_GREY_COLOR),
                SizedBox(height: 1.h),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          ///Item Name
                          TextFieldWidget(
                            controller: itemNameController,
                            readOnly: true,
                            title: AppStrings.itemName.tr,
                            hintText: AppStrings.enterItemName.tr,
                          ),
                          SizedBox(height: 2.h),

                          ///Category Name
                          TextFieldWidget(
                            controller: categoryNameController,
                            title: AppStrings.categoryName.tr,
                            hintText: AppStrings.selectCategoryName.tr,
                            validator: validateCategoryName,
                            textInputAction: TextInputAction.next,
                            maxLength: 10,
                            readOnly: true,
                            onTap: () async {
                              await CreateOrderView().showBottomSheetSelectAndAdd(
                                ctx: context,
                                items: controller.categoryList,
                                title: AppStrings.category.tr,
                                fieldHint: AppStrings.enterCategoryName.tr,
                                searchHint: AppStrings.searchCategoryName.tr,
                                selectedId: selectedCategoryId.isNotEmpty ? selectedCategoryId.toInt() : -1,
                                controller: categoryNameController,
                                onSelect: (id) {
                                  selectedCategoryId = id.toString();
                                  categoryNameController.text = controller.categoryList.firstWhereOrNull((element) => element.categoryId == selectedCategoryId)?.categoryName ?? categoryNameController.text;
                                },
                                selectOnly: true,
                              );
                            },
                          ),
                          SizedBox(height: 2.h),

                          ///Inch
                          TextFieldWidget(
                            controller: inchController,
                            title: AppStrings.size.tr,
                            hintText: AppStrings.enterSize.tr,
                            validator: validateSize,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            maxLength: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Obx(() {
                    return ButtonWidget(
                      onPressed: () async {
                        try {
                          isLoading(true);
                          if (formKey.currentState?.validate() ?? false) {
                            await controller.editInvoiceApiCall(
                              invoiceMetaId: data.invoiceMetaId ?? "",
                              categoryId: selectedCategoryId,
                              inch: inchController.text.trim(),
                            );
                          }
                        } finally {
                          isLoading(false);
                        }
                      },
                      isLoading: isLoading.isTrue,
                      buttonTitle: AppStrings.edit.tr,
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// @function showInvoiceBottomSheet
  /// @description show invoice bottom sheet
  /// @param {BuildContext} ctx - BuildContext object
  /// @param {String} partyName - Party name
  /// @param {String} challanNumber - Challan number
  /// @param {String} createdDate - Created date
  /// @param {List\<InvoiceMeta>} invoiceData - List of invoice data
  /// @returns {Future\<void>} - Returns a Future of a void value
  /// @throws {Exception} - Throws an exception if an error occurs
  Future<void> showInvoiceBottomSheet({
    required BuildContext ctx,
    required String partyName,
    required String challanNumber,
    required String createdDate,
    required List<InvoiceMeta> invoiceData,
  }) async {
    await showBottomSheetWidget(
      context: ctx,
      builder: (context) {
        return InvoiceView(
          partyName: partyName,
          challanNumber: challanNumber,
          createdDate: createdDate,
          invoiceData: invoiceData,
        );
      },
    );
  }
}
