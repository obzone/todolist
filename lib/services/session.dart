import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todolist/configs/index.dart';
import 'package:todolist/util/network_manager.dart';

class SessionService {
  static Future loginWithPassword({@required String username, @required String password}) async {
    return NetworkManager.post('${Config.host}/api/user/login', body: {'username': username, 'password': password});
  }

  static Future debugLogin({@required String username}) {
    return NetworkManager.get('${Config.host}/user/login/debug?mobile=$username');
  }

  static Map<String, dynamic> extractSessionFromResponseJsonString(responseJsonString) {
    try {
      return {'token': jsonDecode(responseJsonString)['token'], 'userId': jsonDecode(responseJsonString)['userId']};
    } catch (e) {
      return null;
    }
  }

  static Future loginWithWechatSsoCode(String code) {
    return NetworkManager.post('${Config.host}/api/sessions/wechatLogin', body: {'code': code});
  }
}
