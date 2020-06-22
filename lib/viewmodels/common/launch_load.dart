import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/viewmodels/base.dart';
import 'package:todolist/viewmodels/list/list.dart';

class LaunchLoadingViewModel extends BaseViewModel {
  bool needShowGuideView = false;

  /// 先检查token
  /// 如果有token，拉取用户资源
  Future checkState() async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      await this._checkIsNeedShowGuideView();
      await TodoListViewModel.getInstance().loadTodoPool();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  Future _checkIsNeedShowGuideView() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isNewInstalled = await prefs.get('isNewInstalled');
      if (isNewInstalled != false) {
        this.needShowGuideView = true;
        prefs.setBool('isNewInstalled', false);
      } else {
        this.needShowGuideView = false;
      }
    } catch (e) {
      print(e);
    }
  }
}
