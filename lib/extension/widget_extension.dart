import 'package:flutter/material.dart';

extension WidgetExtansion on Widget {
  /// add padding
  /// ```dart
  /// Container().paddingAll();
  /// Container().paddingAll(8);
  /// ```
  Widget paddingAll([double? val]) => Padding(
        padding: EdgeInsets.all(val ?? 8),
        child: this,
      );

  /// add padding only
  /// ```dart
  /// Container().paddingAll(top:8,left:5);
  /// ```
  Widget paddingOnly({double? top, double? bottom, double? left, double? right}) => Padding(
        padding: EdgeInsets.only(bottom: bottom ?? 0, left: left ?? 0, right: right ?? 0, top: top ?? 0),
        child: this,
      );

  /// add GesturuDetector
  /// ```dart
  /// Container().gestureDetector(onTap:(){print("tapped")});
  /// ```
  /// 
  /// or 
  /// close all active keyboard
  /// ```dart
  /// Scaffold().gestureDetector(context:context});
  /// ```
  /// 
  Widget gestureDetector({BuildContext? context, VoidCallback? onTap}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap ??
            () {
              FocusScopeNode currentFocus = FocusScope.of(context!);

              if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus!.unfocus();
              }
            },
        child: this,
      );
}
