import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension GetArgs on BuildContext {
  dynamic get arguments {
    return ModalRoute.of(this)?.settings.arguments;
  }
}

extension StringToInt on String {
  int toInt() {
    return int.parse(this);
  }
}

extension StringToIsDouble on String {
  bool isDouble() {
    return contains('.');
  }
}

extension StringToIsInt on String {
  bool isInt() {
    return int.parse(split('.').last) == 0;
  }
}

extension StringToDouble on String {
  double toDouble() {
    return double.parse(this);
  }

  double? toTryDouble() {
    return double.tryParse(this);
  }
}

extension EmptyToZero on String {
  String emptyToZero() {
    if (this == '') {
      return '0';
    } else {
      return this;
    }
  }
}

extension RupeesFormatterFromInt on int {
  String toRupees({String? symbol}) {
    return indianRupeesFormat(symbol: symbol).format(this);
  }
}

extension RupeesFormatterFromDouble on double {
  String toRupees({String? symbol}) {
    return indianRupeesFormat(symbol: symbol).format(this);
  }
}

extension RupeesFormatterFromString on String {
  String toRupees({String? symbol}) {
    if (this != '') {
      return indianRupeesFormat(symbol: symbol).format(int.parse(this));
    } else {
      return '00';
    }
  }
}

indianRupeesFormat({String? symbol}) => NumberFormat.currency(name: "INR", locale: 'en_IN', decimalDigits: 0, symbol: symbol ?? '');

extension RupeesGrandTotalFromList on List {
  String grandTotal() {
    double totalAmount = 0.0;
    for (var element in this) {
      if (element.amount != '' && element.amount != null) {
        totalAmount = totalAmount + element.amount!.toString().toDouble();
      }
    }
    return totalAmount.toString();
  }
}

extension NotContainsAndAddSubString on String {
  String notContainsAndAddSubstring(String requiredString) {
    if (contains(requiredString) == false) {
      return this + requiredString;
    } else {
      return this;
    }
  }
}

extension CleanFileName on String? {
  String? get cleanFileName => this?.replaceAll("/", "_").replaceAll(" ", "_").replaceAll(RegExp(r'[\\:*?"<>|]'), "");
}

extension IsBase64Image on String? {
  bool _isValidImageHeader(String header) {
    return header.startsWith('ffd8') || // JPEG
        header.startsWith('89504e47') || // PNG
        header.startsWith('47494638') || // GIF
        header.startsWith('424d') || // BMP
        header.startsWith('52494646'); // WEBP
  }

  bool get isBase64Image {
    if (this == null) return false;
    if (this?.getMimeType()?.replaceAll("/", ".").isImageFileName == true) return true;
    if (this!.isEmpty || this!.pureBase64.length % 4 != 0) return false;
    final pattern = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
    if (!pattern.hasMatch(this!.pureBase64)) return false;

    try {
      Uint8List bytes = base64.decode(this!.pureBase64);

      // Check common image headers (PNG, JPG, GIF, BMP, WEBP)
      if (bytes.length > 4) {
        String header = bytes.sublist(0, 4).map((e) => e.toRadixString(16).padLeft(2, '0')).join();
        return _isValidImageHeader(header);
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

extension StringWithBase64 on String {
  String get pureBase64 {
    return split(",").last;
  }

  Uint8List? get decodeBase64 {
    try {
      return base64Decode(pureBase64);
    } catch (e) {
      if (kDebugMode) {
        print("Error decoding Base64: $e");
      }
      return null;
    }
  }

  /// Convert FilePath to Uint8List
  String? encodeBase64({String? mimeType}) {
    final file = File(this);
    String base64 = base64Encode(file.readAsBytesSync());
    String base64WithMime = "data:$mimeType;base64,$base64";
    if (!file.existsSync()) return null;
    return mimeType != null ? base64WithMime : base64;
  }

  /// Extracts the MIME type from a Base64 string (e.g., "image/png", "application/pdf").
  String? getMimeType() {
    final RegExp regex = RegExp(r"data:([\w\/\-\+]+);base64,");
    final Match? match = regex.firstMatch(this);
    return match?.group(1);
  }

  /// Extracts the file extension from a Base64 string (e.g., "png", "pdf").
  String? getFileExtension() {
    String? mimeType = getMimeType();
    return mimeType?.split('/').last;
  }
}
