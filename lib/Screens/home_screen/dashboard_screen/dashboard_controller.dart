import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class DashboardController extends GetxController {
  /// @function downloadPdf
  /// @description download pdf from file
  /// @param {File} pdfFile - File object
  /// @returns {Future\<File?>} - Returns a Future of a File object
  /// @throws {Exception} - Throws an exception if an error occurs
  Future<File?> downloadPdf({required File pdfFile}) async {
    if (pdfFile.existsSync()) {
      final directory = Directory('/storage/emulated/0/Download');
      if (directory.existsSync()) {
        final filePath = '${directory.path}/${pdfFile.path.split('/').last}';
        return await pdfFile.copy(filePath);
      }
    }
    return null;
  }

  /// @function printPdf
  /// @description print pdf from file
  /// @param {File} pdfFile - File object
  /// @returns {Future\<bool>} - Returns a Future of a boolean value
  /// @throws {Exception} - Throws an exception if an error occurs
  Future<bool> printPdf({required File pdfFile, bool isLandscape = true}) async {
    if (pdfFile.existsSync()) {
      return await Printing.layoutPdf(
        format: isLandscape ? PdfPageFormat.a5 : PdfPageFormat.a4,
        onLayout: (format) => pdfFile.readAsBytesSync(),
      );
    }
    return false;
  }

  /// @function sharePdf
  /// @description share pdf from file
  /// @param {File} pdfFile - File object
  /// @returns {Future\<bool>} - Returns a Future of a boolean value
  /// @throws {Exception} - Throws an exception if an error occurs
  Future<bool> sharePdf({
    required List<File> pdfFiles,
    required String shareText,
  }) async {
    final existingFiles = pdfFiles.where((element) => element.existsSync()).toList();
    if (existingFiles.isEmpty) {
      return false;
    }
    ShareParams params = ShareParams(
      title: shareText,
      files: existingFiles.map((e) {
        final mimeType = lookupMimeType(e.path);
        return XFile(e.path, mimeType: mimeType);
      }).toList(),
    );
    final result = await SharePlus.instance.share(params);
    return result.status == ShareResultStatus.success;
  }

  /// @function permissionStatus
  /// @description get permission status
  /// @returns {Future<(PermissionStatus storageStatus, PermissionStatus photosStatus)>} - Returns a Future of a tuple of PermissionStatus objects
  /// @throws {Exception} - Throws an exception if an error occurs
  /// @note Android 13+ (Scoped Storage) – storage not needed, only media access
  /// @note Android ≤ 12 – needs storage and possibly photos
  /// @note iOS – only photos access needed
  /// @note If any permission is permanently denied, open app settings
  /// @note Re-check after opening app settings
  /// @note Request if denied
  /// @note Final check before return
  Future<(PermissionStatus storageStatus, PermissionStatus photosStatus)> permissionStatus() async {
    // Default values
    PermissionStatus storageStatus = PermissionStatus.granted;
    PermissionStatus photosStatus = PermissionStatus.granted;

    Future<void> recheckStatus() async {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final androidVersion = androidInfo.version.sdkInt;
        if (androidVersion >= 33) {
          // Android 13+ (Scoped Storage) – storage not needed, only media access
          photosStatus = await Permission.photos.status;
        } else {
          // Android ≤ 12 – needs storage and possibly photos
          storageStatus = await Permission.storage.status;
        }
      } else {
        // iOS – only photos access needed
        photosStatus = await Permission.photos.status;
      }
    }

    await recheckStatus();

    // If any permission is permanently denied
    if (storageStatus.isPermanentlyDenied || photosStatus.isPermanentlyDenied) {
      if (kDebugMode) {
        print("Permission ::::: PermanentlyDenied");
      }
      await openAppSettings();
    }

    // Re-check
    await recheckStatus();

    // Request if denied
    if (storageStatus.isDenied || photosStatus.isDenied) {
      if (kDebugMode) {
        print("Permission ::::: Denied");
      }

      final requests = <Permission>[];

      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final androidVersion = androidInfo.version.sdkInt;
        if (androidVersion < 33 && storageStatus.isDenied) {
          requests.add(Permission.storage);
        }
        if (photosStatus.isDenied) {
          requests.add(Permission.photos);
        }
      } else {
        if (photosStatus.isDenied) {
          requests.add(Permission.photos);
        }
      }

      if (requests.isNotEmpty) {
        await requests.request();
      }
    }

    // Final check before return
    await recheckStatus();

    return (storageStatus, photosStatus);
  }
}
