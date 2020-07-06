import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/viewmodels/list/list.dart';
import 'package:todolist/views/todolist/edit.dart';
import 'package:todolist/views/todolist/operator_selector.dart';
import 'package:todolist/views/todolist/timmer_control.dart';
import 'package:todolist/views/todolist/todo_deadline.dart';

class TodayListView extends StatefulWidget {
  final TodoListViewModel viewModel;

  TodayListView({Key key, @required this.viewModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TodayListView();
  }
}

class _TodayListView extends State<TodayListView> {
  Widget _buildItem(TodoModel model) {
    return Container(
      margin: EdgeInsets.only(left: 8, top: 8, right: 8),
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
                      values: ['edit', 'put back', 'delete'],
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
                        } else if (value == 'put back') {
                          widget.viewModel.removeTodayTodo(model);
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
                  MaterialButton(
                    child: Icon(model.isDone == true ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      widget.viewModel.done(model: model, done: !(model.isDone == true));
                    },
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minWidth: 40,
                  ),
                  Container(
                    child: Flexible(
                      child: Hero(
                        tag: model.id,
                        child: Text(
                          model.name ?? '',
                          maxLines: 2,
                          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'pingfang', fontSize: 18, color: Theme.of(context).primaryColor),
                        ),
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
                            Text(' '),
                          ],
                        ),
                        Container(height: 5),
                        TodoDeadlineView(
                          model: model,
                        ),
                      ],
                    ),
                  ),
                  if (model.isDone != true)
                    TimmerControllerView(
                      model: model,
                      onStartPress: (duration) {
                        widget.viewModel.startToding(model: model, duration: duration);
                      },
                      onComplete: ({bool isDone}) {
                        widget.viewModel.finishDoing(model: model, isDone: isDone);
                      },
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShowFinishedHistoryItem() {
    return Container(
      height: 40,
      margin: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: MaterialButton(
        onPressed: () {
          setState(() {
            widget.viewModel.showTodayDoneList = !(widget.viewModel.showTodayDoneList == true);
          });
        },
        child: Center(
          child: Text('${widget.viewModel.showTodayDoneList == true ? 'hide' : 'show'} finished history..'),
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
          return Container(
            child: ListView(
              children: <Widget>[
                ...((viewmodel.todayList ?? []).where((element) => element.isDone != true).map((model) {
                  return this._buildItem(model);
                })),
                _buildShowFinishedHistoryItem(),
                if (viewmodel.showTodayDoneList)
                  ...((viewmodel.todayList ?? []).where((element) => element.isDone == true).map((model) {
                    return this._buildItem(model);
                  })),
              ],
            ),
          );
        },
      ),
    );
  }
}
