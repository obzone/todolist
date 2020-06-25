import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/services/local_notification.dart';
import 'package:todolist/viewmodels/base.dart';
import 'package:todolist/viewmodels/list/list.dart';

class LaunchLoadingViewModel extends BaseViewModel {
  bool needShowGuideView = false;

  Future checkState() async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      await this._checkIsNeedShowGuideView();
      await LocalNotificationService.getInstance().initialize();
      await TodoListViewModel.getInstance().loadTodosFromLocal();
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
