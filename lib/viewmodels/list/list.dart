import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/services/local_notification.dart';
import 'package:todolist/viewmodels/base.dart';

class TodoListViewModel extends BaseViewModel {
  static TodoListViewModel _viewModel;

  static TodoListViewModel getInstance() {
    if (_viewModel == null) {
      _viewModel = TodoListViewModel();
    }
    return _viewModel;
  }

  List<TodoModel> todayList = [];

  bool showTodayDoneList = false;

  List<TodoModel> todoPool = [];

  bool showPoolDoneList = false;

  String get todayListKey {
    DateTime today = DateTime.now();
    return 'TODO:${today.year}_${today.month}_${today.day}';
  }

  String get todoPoolKey {
    return 'TODO:ALL';
  }

  Future loadTodosFromLocal() async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String todoPoolJsonString = prefs.getString(this.todoPoolKey);
      this.todoPool = jsonDecode(todoPoolJsonString)
              .map((todoModelMap) {
                return TodoModel.fromJson(todoModelMap);
              })
              .toList()
              .cast<TodoModel>() ??
          [];
      String todayListJsonString = prefs.getString(this.todayListKey);
      List<TodoModel> todayTodos = jsonDecode(todayListJsonString)
          .map((todoModelMap) {
            return TodoModel.fromJson(todoModelMap);
          })
          .toList()
          .cast<TodoModel>();
      this.todayList = this.todoPool?.where((poolModel) => todayTodos.any((todayModel) => poolModel.id == todayModel.id))?.toList() ?? [];
      this.todayList.where((element) {
        return element.doing != null && element.doing.endTime == null && ((element.doing.startTime.millisecondsSinceEpoch + element.doing.totalTime * 1000) < DateTime.now().millisecondsSinceEpoch);
      }).forEach((element) {
        element.doing.endTime = DateTime.now();
      });
      this.save();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  Future _saveTodayTodo() async {
    String todayListJsonString = jsonEncode(todayList);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(this.todayListKey, todayListJsonString);
  }

  Future _saveTodoPool() async {
    String todoPoolJsonString = jsonEncode(todoPool);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(this.todoPoolKey, todoPoolJsonString);
  }

  Future startToding(TodoModel model) async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      DoHistoryModel doHistoryModel = DoHistoryModel(startTime: DateTime.now(), totalTime: 60 * 25);
      if (model.doHistories == null) {
        model.doHistories = [doHistoryModel];
      } else {
        model.doHistories.add(doHistoryModel);
      }
      model.updatedTime = DateTime.now();
      LocalNotificationService.getInstance().scheduling(firedTime: DateTime.now().add(Duration(milliseconds: doHistoryModel.totalTime * 1000)), title: model.name, body: 'finished tomato task');
      this._saveTodoPool();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  Future finishDoing(TodoModel model) async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      print(model.doing.startTime.millisecondsSinceEpoch + model.doing.totalTime * 100);
      print(DateTime.now().millisecondsSinceEpoch);
      if (model.doing != null && model.doing.startTime != null && (model.doing.startTime.millisecondsSinceEpoch + (model.doing.totalTime - 1) * 1000) < DateTime.now().millisecondsSinceEpoch) {
        model.doHistories.last.endTime = DateTime.now();
      } else {
        model.doHistories.removeLast();
        LocalNotificationService.getInstance().cancelAll();
      }
      this._saveTodoPool();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  Future save() async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      this._saveTodayTodo();
      this._saveTodoPool();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  Future done({TodoModel model, bool done}) async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      model.isDone = done;
      if (model.doHistories != null && model.doHistories.length > 0 && model.doHistories.last.endTime == null) {
        model.doHistories.last.endTime = DateTime.now();
      }
      LocalNotificationService.getInstance().cancelAll();
      this.save();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  Future addTodayTodo(TodoModel model) async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      todayList.add(model);
      this._saveTodayTodo();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  Future removeTodayTodo(TodoModel model) async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      this.todayList = todayList.where((element) => element.id != model.id).toList();
      this._saveTodayTodo();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  Future createTodo(TodoModel model) async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      todoPool.add(model);
      this._saveTodoPool();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  Future destoryTodo(TodoModel model) async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      this.todayList = todayList.where((element) => element.id != model.id).toList();
      this.todoPool = todoPool.where((element) => element.id != model.id).toList();
      this.save();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }
}
