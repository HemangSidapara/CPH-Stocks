import 'package:flutter/material.dart';
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
