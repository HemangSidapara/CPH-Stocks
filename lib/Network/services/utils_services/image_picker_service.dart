import 'dart:io';

import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  static Future<(String, File)?> pickImage({required ImageSource source, bool isShowLoader = true, int imageQuality = 100}) async {
    bool isGranted = false;
    if (source == ImageSource.camera) {
      if (await Permission.camera.request().isGranted) {
        if (kDebugMode) {
          print("Camera Permission ::::: Granted");
        }
        isGranted = true;
      } else if (await Permission.camera.isDenied) {
        if (kDebugMode) {
          print("Camera Permission ::::: Denied");
        }
        await Permission.camera.request();
      } else if (await Permission.camera.isPermanentlyDenied) {
        if (kDebugMode) {
          print("Camera Permission ::::: PermanentlyDenied");
        }
        await openAppSettings();
      }
    }

    if (source == ImageSource.gallery) {
      if (await Permission.storage.request().isGranted || await Permission.photos.request().isGranted) {
        isGranted = true;
      } else if (await Permission.storage.request().isPermanentlyDenied || await Permission.photos.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.storage.request().isDenied || await Permission.photos.request().isDenied) {
        await Permission.storage.request();
      }
    }

    if (isGranted) {
      XFile? pickedFile = await ImagePicker().pickImage(source: source, imageQuality: imageQuality);

      if (kDebugMode) {
        print("image ::: $pickedFile");
      }

      if (pickedFile == null) {
        if (kDebugMode) {
          print(AppConstance.imageIsNotSelected);
        }
        return null;
      } else {
        File file = File(pickedFile.path);

        if (kDebugMode) {
          print("filePath ::: ${file.path}");
        }

        return (file.path, file);
      }
    }
    return null;
  }

  static Future<List<String>> pickMultiImage({bool isShowLoader = true, int imageQuality = 100}) async {
    if (await Permission.storage.request().isGranted || await Permission.photos.request().isGranted) {
      List<XFile> pickedFileList = await ImagePicker().pickMultiImage(imageQuality: imageQuality);

      if (kDebugMode) {
        print("image ::: ${pickedFileList.length}");
      }

      if (pickedFileList.isEmpty) {
        if (kDebugMode) {
          print(AppConstance.imageIsNotSelected);
        }
        return [];
      } else {
        List<File> fileList = [];
        for (int i = 0; i < pickedFileList.length; i++) {
          fileList.add(File(pickedFileList[i].path));
        }

        if (kDebugMode) {
          print("filePath ::: ${fileList.length}");
        }

        return fileList.map((e) => e.path).toList();
      }
    } else if (await Permission.storage.request().isPermanentlyDenied || await Permission.photos.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied || await Permission.photos.request().isDenied) {
      await Permission.storage.request();
    }

    return [];
  }
}
