import 'package:cph_stocks/Constants/app_utils.dart';
import 'package:cph_stocks/Network/models/notes_models/notes_model.dart';
import 'package:cph_stocks/Network/services/notes_services/notes_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class NotesController extends GetxController {
  RxBool isGetNotesLoading = false.obs;
  RxBool isEditNotesLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxDouble ceilValueForRefresh = 0.0.obs;

  QuillController quillController = QuillController.basic()
    ..formatTextStyle(
      0,
      0,
      Style.fromJson(
        {
          'size': 18.sp,
          'bold': FontWeight.w600,
        },
      ),
    );
  QuillController editedQuillController = QuillController.basic()
    ..formatTextStyle(
      0,
      0,
      Style.fromJson(
        {
          'size': 18.sp,
          'bold': FontWeight.w600,
        },
      ),
    );
  FocusNode focusNode = FocusNode();

  RxBool isNotesEdited = false.obs;

  @override
  void onInit() async {
    super.onInit();
    editedQuillController.addListener(_compareQuillData);
    await getNotesApi();
  }

  void _compareQuillData() {
    final originalJson = quillController.document.toDelta().toJson();
    final editedJson = editedQuillController.document.toDelta().toJson();

    isNotesEdited(originalJson.toString() != editedJson.toString());
  }

  Future<void> getNotesApi({bool isLoading = true}) async {
    try {
      isRefreshing(!isLoading);
      isGetNotesLoading(isLoading);
      final response = await NotesService.getNotesService();
      if (response.isSuccess) {
        NotesModel notesModel = NotesModel.fromJson(response.response?.data);
        if (notesModel.notes != null && notesModel.notes?.isNotEmpty == true) {
          quillController.document = Document.fromDelta(HtmlToDelta().convert(notesModel.notes!));
          editedQuillController.document = Document.fromDelta(HtmlToDelta().convert(notesModel.notes!));
          focusNode.unfocus();
          Utils.unfocus();
        }
      }
    } finally {
      isRefreshing(false);
      isGetNotesLoading(false);
    }
  }

  Future<void> editNotesApi() async {
    try {
      isEditNotesLoading(true);
      final notes = QuillDeltaToHtmlConverter(editedQuillController.document.toDelta().toJson(), ConverterOptions.forEmail()).convert();
      final response = await NotesService.editNotesService(notes: notes);

      if (response.isSuccess) {
        await getNotesApi(isLoading: false);
      }
    } finally {
      isEditNotesLoading(false);
    }
  }
}
