import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/configs/index.dart';

class NetworkManager {
  static Future get(url, {Map<String, String> headers}) async {
    final response = await http.get(Uri.encodeFull(url), headers: headers).timeout(Duration(seconds: Config.httpClientTimeOutDuration));

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
      // return response.body;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw HttpException(response.body ?? '获取失败');
    }
  }

  static Future post(url, {Map<String, String> headers, body, Encoding encoding}) async {
    final response = await http.post(url, headers: headers, body: body, encoding: encoding).timeout(Duration(seconds: Config.httpClientTimeOutDuration));

    try {
      Clipboard.setData(ClipboardData(
        text: '{"app": $body, "node": ${Uri.decodeComponent(response.headers["requestbody"])}}',
      ));
    } catch (e) {}

    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw HttpException(response.body ?? '提交失败');
    }
  }
}
