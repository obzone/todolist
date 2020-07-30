import 'dart:async';

import 'package:todolist/configs/index.dart';
import 'package:todolist/models/exception.dart';
import 'package:wechat_kit/wechat_kit.dart';

class WechatService {
  static WechatService _service;

  static WechatService getInstance() {
    if (_service == null) {
      _service = WechatService();
      _service.wechat = Wechat()
        ..registerApp(
          appId: Config.wechat['appId'],
          universalLink: Config.wechat['universalLink'],
        );
    }
    return _service;
  }

  Wechat wechat;

  Future isWechatInstalled() {
    return wechat.isInstalled();
  }

  Future loginWithWechat() {
    Completer _completer = Completer();
    StreamSubscription<WechatAuthResp> _auth;
    _auth = wechat.authResp().listen((WechatAuthResp resp) {
      if (resp.errorCode != 0) {
        _completer.completeError(CommonException(resp.errorMsg));
      } else {
        _completer.complete(resp.code);
      }
      _auth.cancel();
    });
    wechat.auth(scope: [WechatScope.SNSAPI_USERINFO], state: 'auth');
    return _completer.future;
  }
}
