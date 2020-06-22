import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/models/todo.dart';
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

  Future loadTodoPool() async {
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
      this
          .todayList
          .where((element) =>
              element.doHistories != null &&
              element.doHistories.length > 0 &&
              element.doHistories.last.endTime == null &&
              (element.doHistories.last.startTime.millisecondsSinceEpoch + 1 * 60 * 1000 < DateTime.now().millisecondsSinceEpoch))
          .forEach((element) {
        element.doHistories.last.endTime = DateTime.now();
      });
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
      DoHistoryModel doHistoryModel = DoHistoryModel(startTime: DateTime.now());
      if (model.doHistories == null) {
        model.doHistories = [doHistoryModel];
      } else {
        model.doHistories.add(doHistoryModel);
      }
      this._saveTodoPool();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }

  Future cancelDoing(TodoModel model) async {
    try {
      this.isLoading = true;
      this.e = null;
      notifyListeners();
      if (model.doHistories != null && model.doHistories.length > 0 && model.doHistories.last.startTime != null && model.doHistories.last.endTime == null) {
        model.doHistories.removeLast();
      }
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
      if (model.doHistories != null && model.doHistories.length > 0 && model.doHistories.last.startTime != null) {
        model.doHistories.last.endTime = DateTime.now();
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
      this._saveTodoPool();
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
      this.todayList.sort((model1, model2) {
        return model1.isDone == true ? 1 : -1;
      });
      this.todoPool.sort((model1, model2) {
        return model1.isDone == true ? 1 : -1;
      });
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
      this._saveTodayTodo();
      this._saveTodoPool();
    } catch (e) {
      this.e = e;
    } finally {
      this.isLoading = false;
      notifyListeners();
    }
  }
}
