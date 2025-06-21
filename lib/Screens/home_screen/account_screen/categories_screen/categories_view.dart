import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_styles.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Constants/app_validators.dart';
import 'package:cph_stocks/Network/models/categories_models/get_category_list_model.dart' as get_categories;
import 'package:cph_stocks/Screens/home_screen/account_screen/categories_screen/categories_controller.dart';
import 'package:cph_stocks/Utils/app_formatter.dart';
import 'package:cph_stocks/Widgets/button_widget.dart';
import 'package:cph_stocks/Widgets/close_button_widget.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:cph_stocks/Widgets/divider_widget.dart';
import 'package:cph_stocks/Widgets/loading_widget.dart';
import 'package:cph_stocks/Widgets/no_data_found_widget.dart';
import 'package:cph_stocks/Widgets/refresh_indicator_widget.dart';
import 'package:cph_stocks/Widgets/show_bottom_sheet_widget.dart';
import 'package:cph_stocks/Widgets/textfield_widget.dart';
import 'package:cph_stocks/Widgets/unfocus_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Obx(() {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: controller.isOrderingEnable.isTrue ? AppColors.DARK_GREEN_COLOR : AppColors.TRANSPARENT,
            leadingWidth: 0,
            leading: SizedBox.shrink(),
            actionsPadding: EdgeInsets.zero,
            flexibleSpace: Obx(() {
              return SafeArea(
                child: controller.isOrderingEnable.isTrue
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 0.6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: controller.isOrdering.isFalse
                                      ? () {
                                          controller.isOrderingEnable(false);
                                          controller.searchCategory("");
                                        }
                                      : null,
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
                                  AppStrings.reorderCategories.tr,
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
                                onPressed: controller.isOrdering.isFalse
                                    ? () {
                                        controller.reorderCategoriesApiCall();
                                      }
                                    : null,
                                style: IconButton.styleFrom(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                ),
                                icon: controller.isOrdering.isTrue
                                    ? SizedBox(
                                        width: context.isPortrait ? 5.w : 5.h,
                                        height: context.isPortrait ? 5.w : 5.h,
                                        child: CircularProgressIndicator(
                                          color: AppColors.WHITE_COLOR,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColors.WHITE_COLOR,
                                        size: context.isPortrait ? 7.w : 7.h,
                                      ),
                              );
                            }),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomHeaderWidget(
                                title: AppStrings.categories.tr,
                                titleIcon: AppAssets.categoriesIcon,
                                titleIconSize: 10.w,
                                onBackPressed: () {
                                  Get.back(closeOverlays: true);
                                },
                              ),
                            ),
                            SizedBox(width: 2.w),
                            InkWell(
                              onTap: () {
                                showBottomSheetAddEditCategory(ctx: context);
                              },
                              borderRadius: BorderRadius.circular(360),
                              child: Icon(
                                Icons.add_circle_rounded,
                                color: AppColors.TERTIARY_COLOR,
                                size: 8.w,
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            }),
          ),
          body: SafeArea(
            child: Column(
              children: [
                ///Search Categories
                Obx(() {
                  if (controller.isOrderingEnable.isFalse) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      child: TextFieldWidget(
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColors.SECONDARY_COLOR,
                          size: 5.w,
                        ),
                        prefixIconConstraints: BoxConstraints(maxHeight: 5.h, maxWidth: 8.w, minWidth: 8.w),
                        suffixIcon: InkWell(
                          onTap: () {
                            Utils.unfocus();
                            controller.searchCategoryController.clear();
                            controller.searchCategory(controller.searchCategoryController.text);
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.SECONDARY_COLOR,
                            size: 5.w,
                          ),
                        ),
                        suffixIconConstraints: BoxConstraints(maxHeight: 5.h, maxWidth: 12.w, minWidth: 12.w),
                        hintText: AppStrings.searchCategory.tr,
                        controller: controller.searchCategoryController,
                        onChanged: (value) {
                          controller.searchCategory(value);
                        },
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
                SizedBox(height: 1.h),

                Expanded(
                  child: RefreshIndicatorWidget(
                    onRefresh: () async {
                      await controller.getCategoriesApiCall(isRefresh: true);
                    },
                    child: Obx(() {
                      if (controller.isLoading.isTrue) {
                        return Center(
                          child: LoadingWidget(),
                        );
                      } else if (controller.searchedCategoryList.isEmpty) {
                        return NoDataFoundWidget(
                          subtitle: AppStrings.noDataFound.tr,
                          onPressed: () {
                            controller.getCategoriesApiCall();
                          },
                        );
                      } else {
                        if (controller.isOrderingEnable.isFalse) {
                          return AnimationLimiter(
                            child: ListView.separated(
                              itemCount: controller.searchedCategoryList.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h).copyWith(bottom: 5.h),
                              itemBuilder: (context, index) {
                                final data = controller.searchedCategoryList[index];
                                return CategoryTileWidget(
                                  index: index,
                                  data: data,
                                  ctx: context,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 1.5.h);
                              },
                            ),
                          );
                        } else {
                          return ReorderableListView.builder(
                            itemCount: controller.searchedCategoryList.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h).copyWith(bottom: 5.h),
                            proxyDecorator: (child, index, animation) {
                              return child;
                            },
                            itemBuilder: (context, index) {
                              final data = controller.searchedCategoryList[index];
                              return CategoryTileWidget(
                                index: index,
                                data: data,
                                ctx: context,
                              );
                            },
                            onReorder: (oldIndex, newIndex) {
                              controller.reorderCategory(oldIndex, newIndex);
                            },
                          );
                        }
                      }
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget CategoryTileWidget({
    required int index,
    required get_categories.CategoryData data,
    required BuildContext ctx,
  }) {
    return GestureDetector(
      key: ValueKey(index),
      onLongPress: controller.isOrderingEnable.isFalse
          ? () {
              controller.isOrderingEnable(true);
              controller.searchCategoryController.clear();
              controller.searchCategory("");
            }
          : null,
      child: AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: Card(
              color: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(() {
                return ExpansionTile(
                  title: Row(
                    children: [
                      if (controller.isOrderingEnable.isTrue) ...[
                        ReorderableDragStartListener(
                          index: index,
                          child: Icon(
                            Icons.drag_indicator_rounded,
                            color: AppColors.SECONDARY_COLOR,
                            size: 5.w,
                          ),
                        ),
                        SizedBox(width: 2.w),
                      ],

                      ///Category Name
                      Expanded(
                        child: Text(
                          data.categoryName ?? "",
                          style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                        ),
                      ),

                      ///Price
                      Text(
                        data.categoryPrice?.isNotEmpty == true ? NumberFormat.currency(locale: "hi_IN", symbol: "₹ ").format(data.categoryPrice!.toDouble()) : "",
                        style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                      ),
                      SizedBox(width: 2.w),
                    ],
                  ),
                  tilePadding: EdgeInsets.symmetric(horizontal: 3.w),
                  showTrailingIcon: controller.isOrderingEnable.isFalse,
                  trailing: ElevatedButton(
                    onPressed: () {
                      showBottomSheetAddEditCategory(ctx: ctx, isEdit: true, categoryData: data);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.WARNING_COLOR,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                      maximumSize: Size.square(8.w),
                      minimumSize: Size.square(8.w),
                      elevation: 4,
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 5.w,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                  dense: true,
                  collapsedBackgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                  backgroundColor: AppColors.LIGHT_SECONDARY_COLOR.withValues(alpha: 0.7),
                  iconColor: AppColors.SECONDARY_COLOR,
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide.none,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide.none,
                  ),
                  childrenPadding: EdgeInsets.only(bottom: 2.h),
                  children: [
                    DividerWidget(
                      color: AppColors.SECONDARY_COLOR.withValues(alpha: 0.35),
                      thickness: 1,
                    ),

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
                            data.createdDate ?? "",
                            style: AppStyles.size16w600.copyWith(color: AppColors.SECONDARY_COLOR),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showBottomSheetAddEditCategory({
    required BuildContext ctx,
    bool isEdit = false,
    get_categories.CategoryData? categoryData,
  }) async {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController categoryNameController = TextEditingController(text: categoryData?.categoryName);
    TextEditingController categoryPriceController = TextEditingController(text: categoryData?.categoryPrice);

    RxBool isAddLoading = false.obs;

    await showBottomSheetWidget(
      context: ctx,
      builder: (context) {
        final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
        return UnfocusWidget(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: keyboardPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///Title & Back
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            isEdit ? AppStrings.editCategory.tr : AppStrings.addCategory.tr,
                            style: AppStyles.size18w600,
                          ),
                        ),
                        CloseButtonWidget(),
                      ],
                    ),
                  ),
                  DividerWidget(),

                  ///Fields
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            ///Category Name
                            TextFieldWidget(
                              controller: categoryNameController,
                              title: AppStrings.categoryName.tr,
                              hintText: AppStrings.enterCategoryName.tr,
                              maxLength: 10,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.pleaseEnterCategoryName.tr;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 2.h),

                            ///Category Price
                            TextFieldWidget(
                              controller: categoryPriceController,
                              title: AppStrings.categoryPrice.tr,
                              hintText: AppStrings.enterCategoryPrice.tr,
                              maxLength: 5,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.pleaseEnterCategoryPrice.tr;
                                } else if (!AppValidators.doubleValidator.hasMatch(value)) {
                                  return AppStrings.pleaseEnterValidCategoryPrice.tr;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),

                  ///Buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w).copyWith(bottom: 2.h),
                    child: Obx(() {
                      return ButtonWidget(
                        onPressed: () async {
                          Utils.unfocus();
                          try {
                            isAddLoading(true);
                            if (formKey.currentState?.validate() ?? false) {
                              if (isEdit) {
                                await controller.editCategoryApiCall(
                                  categoryId: categoryData?.categoryId ?? "",
                                  categoryName: categoryNameController.text.trim(),
                                  categoryPrice: categoryPriceController.text.trim(),
                                );
                              } else {
                                await controller.createCategoryApiCall(
                                  categoryName: categoryNameController.text.trim(),
                                  categoryPrice: categoryPriceController.text.trim(),
                                );
                              }
                            }
                          } finally {
                            isAddLoading(false);
                          }
                        },
                        isLoading: isAddLoading.isTrue,
                        buttonTitle: isEdit ? AppStrings.edit.tr : AppStrings.add.tr,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
