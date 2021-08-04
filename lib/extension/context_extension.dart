library flutter_app_manager;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ContextExtension on BuildContext {
  /// get theme => colorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// get theme => textTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// get colorSchema => primary
  Color get primary => this.colorScheme.primary;

  /// get colorSchema => secondary
  Color get secondary => this.colorScheme.secondary;
  TextStyle? get dataTextStyle => Theme.of(this).dataTableTheme.dataTextStyle;
  void get back => Navigator.of(this).pop();

  Size get getSize => MediaQuery.of(this).size;
  double get getHeight => this.getSize.height;
  double get getWidth => this.getSize.width;

  /// get global provider value
  /// ```dart
  /// context.state<YourModel>();
  /// context.state<YourModel>(false);
  /// ```
  T state<T>([bool? listen]) => Provider.of<T>(this, listen: listen ?? true);

  /// Navigator back with paramaters
  /// ```dart
  /// context.backWithParam(value);
  /// ```
  backWithParam(param) => Navigator.of(this).pop(param);

  dynamic push(model) => Navigator.push(this, MaterialPageRoute(builder: (_) => model));

  pushNamedAndRemoveUntil(String path) => Navigator.pushNamedAndRemoveUntil(this, path, (route) => false);
  /// push and remove until all route
  pushReplement(model) =>
      Navigator.pushAndRemoveUntil(this, MaterialPageRoute(builder: (_) => model), (route) => false);
  /// push and remove last route
  pushRep(model) => Navigator.pushReplacement(this, MaterialPageRoute(builder: (_) => model));
  String get tl => " ₺";
  String get m3 => " m³";

  double get labelDim => MediaQuery.of(this).size.width * .04;
  double get titleDim => MediaQuery.of(this).size.width * .1;
  double get qrDim => MediaQuery.of(this).size.width * 0.06;

  void showSnackBar(Widget child) => ScaffoldMessenger.of(this).showSnackBar(new SnackBar(content: child));
}
