import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/models/exception.dart';
import 'package:todolist/services/session.dart';
import 'package:todolist/services/wechat.dart';
import 'package:todolist/viewmodels/base.dart';

class SessionViewModel extends BaseViewModel {
  static SessionViewModel _viewModel;

  static SessionViewModel getInstance() {
    if (_viewModel == null) {
      _viewModel = SessionViewModel();
    }
    return _viewModel;
  }

  String token;

  String username;
  String password;

  bool isWechatInstalled;

  void debugLogin() async {
    try {
      this.e = null;
      this.isLoading = true;
      notifyListeners();
      if (this.password != 'pagoda123') throw CommonException('账户或密码不正确');
      final response = await SessionService.debugLogin(username: this.username);
      final session = await compute(SessionService.extractSessionFromResponseJsonString, response);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', session['token']).catchError((e) {
        print(e);
      });
      prefs.setString('userId', session['userId']).catchError((e) {
        print(e);
      });
      this.token = session['token'];
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  void checkWechatIsInstall() async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      isWechatInstalled = await WechatService.getInstance().isWechatInstalled();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  loginWithWechat() async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      if (isWechatInstalled == null) {
        isWechatInstalled = await WechatService.getInstance().isWechatInstalled();
      }
      if (isWechatInstalled != true) throw CommonException('没有安装微信');
      String code = await WechatService.getInstance().loginWithWechat();
      String token = await SessionService.loginWithWechatSsoCode(code);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      this.token = token;
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  void logout() async {
    try {
      this.e = null;
      this.isLoading = true;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUser');
      await prefs.remove('token');
      this.token = null;
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }
}
