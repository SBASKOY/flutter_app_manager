library flutter_app_manager;
import 'dart:convert';

import 'package:http/http.dart';

import 'base_error.dart';

class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance {
    if (_instance == null) {
      _instance = NetworkManager._init();
    }
    return _instance!;
  }

  late final String baseUrl;
  static setUrl(String url) {
    NetworkManager._instance!.baseUrl = url;
  }

  NetworkManager._init();
  Map<String, String> _postOptionsWithToken(String token) {
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $token",
    };
  }

  Map<String, String> _postOptions() {
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  Future httpGet(String path, {dynamic model, String? token}) async {
    final response = await get(
      Uri.parse(baseUrl + path),
      headers: token == null ? this._postOptions() : this._postOptionsWithToken(token),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is List) {
        return responseBody.map((e) => model.fromJson(e)).toList();
      } else if (responseBody is Map) {
        return model.fromJson(responseBody);
      }
      return response.body;
    } else {
      this.throwError(response);
    }
  }

  Future httpGetString(String path, {String? token}) async {
    final response = await get(
      Uri.parse(baseUrl + path),
      headers: token == null ? this._postOptions() : this._postOptionsWithToken(token),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      this.throwError(response);
    }
  }

  Future httpPost(String path, {required dynamic model, Map? data, String? token}) async {
    final response = await post(Uri.parse((path.contains("http") ? path : baseUrl + path)),
        headers: token == null ? this._postOptions() : this._postOptionsWithToken(token),
        body: data != null ? jsonEncode(data) : "");
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      if (responseBody is List) {
        return responseBody.map((e) => model.fromJson(e)).toList();
      } else if (responseBody is Map) {
        return model.fromJson(responseBody);
      }
      return response.body;
    } else {
      this.throwError(response);
    }
  }

  void throwError(Response response) {
    if (response.statusCode == 400) {
      throw BadRequestError(response.body);
    } else if (response.statusCode == 401) {
      throw AuthorizeError.to();
    } else if (response.statusCode == 404) {
      throw NotFound.to();
    } else {
      throw InternalServerError(msg: "${response.statusCode} ${response.body}");
    }
  }

  Future httpPostString(String path, {Map? data, String? token}) async {
    final response = await post(Uri.parse((path.contains("http") ? path : baseUrl + path)),
        headers: token == null ? this._postOptions() : this._postOptionsWithToken(token),
        body: data != null ? jsonEncode(data) : "");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      this.throwError(response);
    }
  }

  Future<Response> httpPostRes({required String path, data, String? token}) async {
    final response = await post(Uri.parse(path.contains("http") ? path : baseUrl + path),
        headers: token == null ? this._postOptions() : this._postOptionsWithToken(token),
        body: data != null ? jsonEncode(data) : "");
    return response;
  }
}
