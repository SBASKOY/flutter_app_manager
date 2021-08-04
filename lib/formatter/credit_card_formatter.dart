import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var a = newValue.text
        .replaceAll(" ", "")
        .replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)} ")
        .trimRight();

    return TextEditingValue(text: a.toString(), selection: TextSelection.collapsed(offset: a.length));
  }
}

class ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var a = newValue.text.replaceAll("/", "").replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)}/");
    if(a.endsWith("/"))a=a.substring(0,a.length-1);

    return TextEditingValue(text: a.toString(), selection: TextSelection.collapsed(offset: a.length));
  }
}
