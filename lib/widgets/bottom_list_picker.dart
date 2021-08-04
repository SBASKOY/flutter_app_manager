import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_manager/mixins/helper.dart';

import '../network/network_manager.dart';
import '../extension/context_extension.dart';

class StreamTextFieldHelper {
  static Widget showField(Stream stream, Function(String) onChanged, String labelText, bool isNumber,
      {TextEditingController? controller,
      bool? isPassword,
      InputDecoration? decoration,
      List<TextInputFormatter>? formatter}) {
    return StreamBuilder(
      stream: stream,
      builder: (c, snap) {
        return TextField(
          obscureText: isPassword ?? false,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters: formatter ?? (isNumber ? [FilteringTextInputFormatter.allow(new RegExp("[0-9.]"))] : []),
          controller: controller ?? null,
          onChanged: onChanged,
          decoration: decoration ??
              InputDecoration(
                  labelText: labelText,
                  border: OutlineInputBorder(),
                  errorText: snap.hasError ? snap.error.toString() : null),
        );
      },
    );
  }

  static Widget showMultiLineField(Stream stream, Function(String) onChanged, String labelText, bool isNumber,
      {TextEditingController? controller,
      bool? isPassword,
      InputDecoration? decoration,
      List<TextInputFormatter>? formatter}) {
    return StreamBuilder(
      stream: stream,
      builder: (c, snap) {
        return TextField(
          obscureText: isPassword ?? false,
          maxLines: 4,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters: formatter ?? (isNumber ? [FilteringTextInputFormatter.allow(new RegExp("[0-9.]"))] : []),
          controller: controller ?? null,
          onChanged: onChanged,
          decoration: decoration ??
              InputDecoration(
                  labelText: labelText,
                  border: OutlineInputBorder(),
                  errorText: snap.hasError ? snap.error.toString() : null),
        );
      },
    );
  }
}

class PickerModel {
  int index;
  String name;
  PickerModel({required this.index, required this.name});
}

class BottomListPicker extends StatefulWidget {
  final model;
  final String path;
  final String leftText;
  final int? selectedIndex;
  final List? data;
  final String token;
  const BottomListPicker(
      {Key? key,
      required this.model,
      required this.path,
      required this.leftText,
      this.selectedIndex,
      this.data,
      required this.token})
      : super(key: key);
  @override
  _BottomListPickerState createState() => _BottomListPickerState(this.token);

  /// send map value
  /// return id or text
  /// ```dart
  /// var index = val["selectedIndex"];
  ///  var data = val["data"] as List;
  ///  var selected = data[index];
  ///  if ((isID ?? false)) {
  ///    return selected.toJson()["id"].toString();
  ///  }
  ///  return selected.toJson()["name"];
  /// ```
  static String getselected(Map val, {bool? isID}) {
    var index = val["selectedIndex"];
    var data = val["data"] as List;
    var selected = data[index];
    if ((isID ?? false)) {
      return selected.toJson()["id"].toString();
    }
    return selected.toJson()["name"];
  }

  /// this is show bottom list picker
  /// #### return value
  /// ```json
  /// {
  /// "selectedIndex":1,
  /// "data":[
  /// {"id":1,"depoAdi": "adad", "name": "adad"},
  /// {"id":1,"depoAdi": "asda", "name": "asda"}]
  /// }
  /// ```
  /// #### data example
  /// ```json
  /// [
  /// {"id":1,"depoAdi": "adad", "name": "adad"},
  /// {"id":1,"depoAdi": "asda", "name": "asda"},
  /// ]
  /// ```
  /// #### your stream example
  /// ```dart
  /// final tip = new BehaviorSubject<Map?>();
  /// ```
  /// #### onChanged example
  /// ```dart
  /// void onTipChanged(Map val) => tip.sink.add(val);
  /// ```
  /// #### get selected id or text
  /// ```dart
  /// var selectedId=BottomListPicker.getSelected(tip.value!,isID=true);
  /// var selectedText=BottomListPicker.getSelected(tip.value!);
  /// ```
  ///
  ///
  static Widget show(Stream<Map?> stream, Function(Map) onChanged, TextEditingController controller, model, String path,
      String leftText,String token,
      {String? labelText}) {
    return StreamBuilder<Map?>(
        stream: stream,
        builder: (context, snap) {
          return TextField(
            readOnly: true,
            controller: controller,
            onTap: () async {
              var selectedIndex;
              var data;
              if (snap.hasData) {
                selectedIndex = snap.data!["selectedIndex"];
                data = snap.data!["data"];
              }
              var json = await showBottomPickerDialog(context, model, path, leftText,token,
                  selectedIndex: selectedIndex, data: data);
              if (json == null) {
                return;
              } else {
                if (json["data"] == null || json["selectedIndex"] == null) {
                  return;
                }
              }

              onChanged(json);
              var index = json["selectedIndex"];
              var selected = (json["data"] as List)[index];

              controller.text = selected.toJson()["name"];
            },
            decoration: InputDecoration(
                labelText: labelText ?? leftText,
                suffixIcon: Icon(Icons.arrow_forward_ios),
                errorText: snap.hasError ? snap.error.toString() : null),
          );
        });
  }

  static showBottomPickerDialog(BuildContext context, model, String path, String leftText,String token
      ,{int? selectedIndex, List? data}) async {
    return await showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(5),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return BottomListPicker(
            model: model,
            path: path,
            leftText: leftText,
            selectedIndex: selectedIndex,
             token: token,
          );
        });
  }
}

class _BottomListPickerState extends State<BottomListPicker> with Helper  {
  final String token;
  List<PickerModel> model = [];
  List? modelList;
  String err = "";
  bool loading = false;
  int selectedIndex = 0;

  _BottomListPickerState(this.token);

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex ?? 0;
    getData();
  }

  Future<void> getData() async {
    try {
      setState(() => loading = true);
      List res = widget.data ??
          await NetworkManager.instance
              .httpPost(widget.path, model: widget.model, token: this.token, data: {"data": ""});
      modelList = res;
      for (int i = 0; i < res.length; i++) {
        Map<String, dynamic> json = res[i].toJson();

        model.add(new PickerModel(index: i, name: json["name"]));
      }
      setState(() => loading = false);
    } catch (e) {
      setState(() {
        loading = false;
        err = getErrorMessage(e);
      });
      print(err);
      print(widget.path);
    }
  }

  void back() {
    context.backWithParam({"selectedIndex": selectedIndex, "data": modelList});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(widget.leftText),
              ),
              TextButton(
                onPressed: back,
                child: Text(
                  "Tamam",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          Container(
              padding: EdgeInsets.all(8),
              height: 200,
              alignment: Alignment.center,
              child: err != ''
                  ? Text(
                      err,
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
                      ),
                    )
                  : loading == false
                      ? CupertinoPicker(
                          onSelectedItemChanged: (index) {
                            selectedIndex = model[index].index;
                          },
                          scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                          itemExtent: 35,
                          looping: false,
                          children: List.generate(model.length, (i) {
                            return Text(
                              model[i].name,
                              textAlign: TextAlign.center,
                            );
                          }))
                      : progressIndicator(context)),
        ],
      ),
    );
  }
}
