library flutter_app_manager;

import 'package:flutter/material.dart';

class NavigatorManager {
  static NavigatorManager? _instance;

  /// set first context
  /// ```dart
  /// class MyApp{
  /// static final navKey = new GlobalKey<NavigatorState>();
  /// NavigatorManager.setContext(navKey);
  /// Widget build(BuildContext context) {
  ///     return MaterialApp();
  ///   }
  /// }
  /// ```
  static NavigatorManager get instance {
    if (_instance == null) {
      _instance = NavigatorManager._init();
    }
    return _instance!;
  }

  late final BuildContext context;

  NavigatorManager._init() {
    print("_________init_______________");
    //context = MyApp.navKey.currentState!.context;
  }
  static setContext(GlobalKey<NavigatorState> key) {
    print("_________setContext_______________");
    NavigatorManager.instance.context = key.currentState!.context;
  }

  void get back => Navigator.of(this.context).pop();
  backWithParam(param) => Navigator.of(this.context).pop(param);
  dynamic push(model) => Navigator.push(this.context, MaterialPageRoute(builder: (_) => model));
  pushNamedAndRemoveUntil(String path) => Navigator.pushNamedAndRemoveUntil(this.context, path, (route) => false);

  /// route => false
  pushReplement(model) =>
      Navigator.pushAndRemoveUntil(this.context, MaterialPageRoute(builder: (_) => model), (route) => false);
  pushRep(model) => Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (_) => model));
}
