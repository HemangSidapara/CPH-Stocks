import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_strings.dart';
import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Screens/home_screen/notes_screen/notes_controller.dart';
import 'package:cph_stocks/Widgets/custom_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class NotesView extends GetView<NotesController> {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomHeaderWidget(
                    title: AppStrings.notes.tr,
                    titleIcon: AppAssets.notesAnim,
                    titleIconSize: 8.5.w,
                  ),
                  Obx(() {
                    return IconButton(
                      onPressed: controller.isRefreshing.value
                          ? () {}
                          : () async {
                              Utils.unfocus();
                              controller.getNotesApi(isLoading: false);
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
            SizedBox(height: 2.h),

            ///Notes
            Align(
              alignment: Alignment.centerLeft,
              child: quill.QuillToolbar.simple(
                controller: controller.editedQuillController,
                configurations: quill.QuillSimpleToolbarConfigurations(
                  color: AppColors.SECONDARY_COLOR,
                  buttonOptions: quill.QuillSimpleToolbarButtonOptions(
                    undoHistory: quill.QuillToolbarHistoryButtonOptions(
                      iconTheme: quill.QuillIconTheme(
                        iconButtonUnselectedData: quill.IconButtonData(
                          disabledColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: AppColors.PRIMARY_COLOR, width: 1.5),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          color: AppColors.PRIMARY_COLOR,
                        ),
                        iconButtonSelectedData: quill.IconButtonData(
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: AppColors.PRIMARY_COLOR, width: 1.5),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                    redoHistory: quill.QuillToolbarHistoryButtonOptions(
                      iconTheme: quill.QuillIconTheme(
                        iconButtonUnselectedData: quill.IconButtonData(
                          disabledColor: AppColors.LIGHT_SECONDARY_COLOR.withOpacity(0.7),
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: AppColors.PRIMARY_COLOR, width: 1.5),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          color: AppColors.PRIMARY_COLOR,
                        ),
                        iconButtonSelectedData: quill.IconButtonData(
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: AppColors.PRIMARY_COLOR, width: 1.5),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                    fontSize: quill.QuillToolbarFontSizeButtonOptions(
                      style: TextStyle(
                        color: AppColors.PRIMARY_COLOR,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                    base: quill.QuillToolbarBaseButtonOptions(
                      iconTheme: quill.QuillIconTheme(
                        iconButtonSelectedData: quill.IconButtonData(
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.DARK_GREEN_COLOR,
                          ),
                        ),
                        iconButtonUnselectedData: quill.IconButtonData(
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: AppColors.PRIMARY_COLOR, width: 1.5),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                  ),
                  multiRowsDisplay: false,
                  showFontFamily: false,
                  showHeaderStyle: false,
                  showCodeBlock: false,
                  showIndent: false,
                  showLink: false,
                  showColorButton: false,
                  showBackgroundColorButton: false,
                  showInlineCode: false,
                  showClipboardCut: false,
                  showClipboardCopy: false,
                  showClipboardPaste: false,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR,
                    border: Border.all(
                      color: AppColors.LIGHT_GREY_COLOR,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: quill.QuillEditor.basic(
                      controller: controller.editedQuillController,
                      focusNode: FocusNode(),
                      scrollController: ScrollController(),
                      configurations: quill.QuillEditorConfigurations(
                        placeholder: AppStrings.description.tr,
                        autoFocus: false,
                        expands: true,
                        customStyles: quill.DefaultStyles(
                          paragraph: quill.DefaultTextBlockStyle(
                            TextStyle(
                              color: AppColors.SECONDARY_COLOR,
                              fontSize: 18.sp,
                            ),
                            quill.HorizontalSpacing.zero,
                            quill.VerticalSpacing.zero,
                            quill.VerticalSpacing.zero,
                            null,
                          ),
                          placeHolder: quill.DefaultTextBlockStyle(
                            TextStyle(
                              color: AppColors.HINT_GREY_COLOR,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            quill.HorizontalSpacing.zero,
                            quill.VerticalSpacing.zero,
                            quill.VerticalSpacing.zero,
                            null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            ///Actions
            Obx(() {
              if (controller.isNotesEdited.isTrue) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ///Cancel
                      ElevatedButton(
                        onPressed: () {
                          controller.editedQuillController.document = quill.Document.fromDelta(
                            HtmlToDelta().convert(
                              QuillDeltaToHtmlConverter(
                                controller.quillController.document.toDelta().toJson(),
                                ConverterOptions.forEmail(),
                              ).convert(),
                            ),
                          );
                          SystemChannels.textInput.invokeMethod('TextInput.hide');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.DARK_RED_COLOR,
                          elevation: 4,
                          fixedSize: Size(38.w, 5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),

                      ///Edit
                      Obx(() {
                        return ElevatedButton(
                          onPressed: () async {
                            Utils.unfocus();
                            await controller.editNotesApi();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.WARNING_COLOR,
                            elevation: 4,
                            fixedSize: Size(38.w, 5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: controller.isEditNotesLoading.isTrue
                              ? SizedBox(
                                  width: 5.w,
                                  height: 5.w,
                                  child: CircularProgressIndicator(
                                    color: AppColors.WHITE_COLOR,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Icon(
                                  Icons.edit_rounded,
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                        );
                      }),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
          ],
        ),
      ),
    );
  }
}
