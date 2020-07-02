import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/viewmodels/list/list.dart';
import 'package:todolist/views/todolist/edit.dart';
import 'package:todolist/views/todolist/operator_selector.dart';

class TodoPoolView extends StatefulWidget {
  final TodoListViewModel viewModel;

  TodoPoolView({Key key, @required this.viewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TodoPoolView();
  }
}

class _TodoPoolView extends State<TodoPoolView> {
  Widget _buildAddItem() {
    return Container(
      height: 45,
      color: Colors.white,
      margin: EdgeInsets.all(10),
      child: MaterialButton(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder<void>(
              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                return TodoEditView(
                  viewModel: TodoListViewModel.getInstance(),
                  transitionAnimation: animation,
                );
              },
            ),
          );
        },
        child: Center(
          child: Hero(
            tag: 'add',
            child: Container(
              child: Text(
                '+ add',
                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShowFinishedHistoryItem() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: MaterialButton(
        onPressed: () {
          setState(() {
            widget.viewModel.showPoolDoneList = !(widget.viewModel.showPoolDoneList == true);
          });
        },
        child: Center(
          child: Text('${widget.viewModel.showPoolDoneList == true ? 'hide' : 'show'} finished history..'),
        ),
      ),
    );
  }

  _onModelCheckboxPress(BuildContext context, TodoModel model) {
    if (widget.viewModel.todayList.any((element) => element.id == model.id)) {
      widget.viewModel.removeTodayTodo(model);
    } else {
      widget.viewModel.addTodayTodo(model);
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        content: Text('added to today list'),
      ));
    }
  }

  Widget _buildItem(TodoModel model) {
    bool isInToday = widget.viewModel.todayList.any((element) => element.id == model.id);
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(color: Colors.white),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () {},
        onLongPress: model.isDone == true
            ? null
            : () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return OpearateSelectorView(
                      values: ['edit', 'delete'],
                      onValueChange: (value) {
                        if (value == 'edit') {
                          Navigator.of(context).push(
                            PageRouteBuilder<void>(
                              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                return TodoEditView(
                                  viewModel: TodoListViewModel.getInstance(),
                                  transitionAnimation: animation,
                                  model: model,
                                );
                              },
                            ),
                          );
                        } else if (value == 'delete') {
                          widget.viewModel.destoryTodo(model);
                        }
                      },
                    );
                  },
                );
              },
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Builder(
                    builder: (context) {
                      return MaterialButton(
                        child: Icon(model.isDone == true ? Icons.radio_button_checked : isInToday ? Icons.check_box : Icons.check_box_outline_blank, color: Theme.of(context).primaryColor),
                        onPressed: () {
                          if (model.isDone == true) {
                            widget.viewModel.done(model: model, done: false);
                          } else {
                            this._onModelCheckboxPress(context, model);
                          }
                        },
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minWidth: 40,
                      );
                    },
                  ),
                  Container(
                    child: Flexible(
                      child: Text(
                        model.name ?? '',
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'pingfang', fontSize: 18, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ...?model.doHistories?.map(
                              (history) => Text(
                                '✗ ',
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                        if (model.doHistories != null && model.doHistories.length > 0)
                          Container(
                            height: 5,
                          ),
                        Container(
                          // margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            model.type ?? '',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<TodoListViewModel>(
        builder: (context, viewmodel, child) {
          return ListView(
            children: <Widget>[
              _buildAddItem(),
              ...(viewmodel.todoPool ?? []).where((element) => element.isDone != true).map((model) => this._buildItem(model)),
              _buildShowFinishedHistoryItem(),
              if (viewmodel.showPoolDoneList == true) ...(viewmodel.todoPool ?? []).where((element) => element.isDone == true).map((model) => this._buildItem(model)),
            ],
          );
        },
      ),
    );
  }
}
