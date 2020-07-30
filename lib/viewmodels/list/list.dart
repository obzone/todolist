import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/services/local_notification.dart';
import 'package:todolist/viewmodels/base.dart';
import 'package:wakelock/wakelock.dart';

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

  _sortTodos() {
    todoPool.sort((prev, current) {
      if (todayList.any((element) => element == current)) {
        return 1;
      } else if (prev.updatedTime.isBefore(current.updatedTime) && !todayList.any((element) => element == prev)) {
        return 1;
      } else {
        return 0;
      }
    });
    todayList.sort((prev, current) {
      if (prev.updatedTime.isBefore(current.updatedTime)) {
        return 1;
      } else {
        return 0;
      }
    });
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
        element.doing.endTime = element.doing.startTime.add(Duration(seconds: element.doing.totalTime));
        element.updatedTime = DateTime.now();
      });
      _sortTodos();
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

  Future startToding({TodoModel model, int duration}) async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      DoHistoryModel doHistoryModel = DoHistoryModel(startTime: DateTime.now(), totalTime: duration ?? 60 * 25);
      if (model.doHistories == null) {
        model.doHistories = [doHistoryModel];
      } else {
        model.doHistories.add(doHistoryModel);
      }
      Wakelock.enable();
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

  /// 完成一次番茄
  Future finishDoing({TodoModel model, bool isDone}) async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      if (isDone == true) {
        if (model.doing == null || model.doing.startTime == null || (model.doing.startTime.millisecondsSinceEpoch + (model.doing.totalTime - 1) * 1000) >= DateTime.now().millisecondsSinceEpoch) {
          model.doHistories.last.endTime = model.doing.startTime.add(Duration(seconds: model.doing.totalTime));
          LocalNotificationService.getInstance().cancelAll();
        }
      } else {
        model.doHistories.removeLast();
        LocalNotificationService.getInstance().cancelAll();
      }
      Wakelock.disable();
      model.updatedTime = DateTime.now();
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
      this._sortTodos();
      this.save();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  /// 完成任务
  Future done({TodoModel model, bool done}) async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      if (!todayList.contains(model)) {
        todayList.add(model);
      }
      model.isDone = done;
      if (model.doHistories != null && model.doHistories.length > 0 && model.doHistories.last.endTime == null) {
        model.doHistories.last.endTime = DateTime.now();
      }
      LocalNotificationService.getInstance().cancelAll();
      model.updatedTime = DateTime.now();
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
      _sortTodos();
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
      this._sortTodos();
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
      _sortTodos();
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
