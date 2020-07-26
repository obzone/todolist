import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:todolist/models/todo.dart';

class TodoReportView extends StatefulWidget {
  final TodoModel model;

  TodoReportView({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TodoReportView(doHistories: model.doHistories);
  }
}

class _TodoReportView extends State<TodoReportView> {
  List<DoHistoryModel> doHistories;
  int dayMaxHistoryNumber = 0;
  Map<String, List<DoHistoryModel>> groupedhistories = Map();

  _TodoReportView({this.doHistories}) : super();

  @override
  void initState() {
    super.initState();
    doHistories.forEach((doHistory) {
      String dateString = DateFormat('yyyy-MM-dd').format(doHistory.startTime);
      List<DoHistoryModel> histories = groupedhistories[dateString];
      if (histories == null) {
        groupedhistories[dateString] = [doHistory];
      } else {
        histories.add(doHistory);
      }
    });
    groupedhistories.values.forEach((element) {
      if (dayMaxHistoryNumber < element.length) {
        dayMaxHistoryNumber = element.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.model.name ?? ''),
          ),
          body: SizedBox(
            height: constraints.maxHeight / 2,
            child: SfCartesianChart(
              // trackballBehavior: TrackballBehavior(
              //   enable: true,
              //   shouldAlwaysShow: true,
              //   activationMode: ActivationMode.singleTap,
              //   tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              // ),
              // legend: Legend(isVisible: true, position: LegendPosition.top),
              primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(color: Colors.transparent),
                axisLine: AxisLine(color: Colors.transparent),
              ),
              primaryYAxis: NumericAxis(title: AxisTitle(text: '(minutes)', alignment: ChartAlignment.center)),
              palette: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withGreen(100),
                Theme.of(context).primaryColor.withGreen(200),
                Theme.of(context).primaryColor.withGreen(300),
              ],
              series: <ChartSeries>[
                for (var i = 0; i < dayMaxHistoryNumber; i++)
                  StackedColumnSeries<String, String>(
                    dataSource: groupedhistories.keys.toList(),
                    xValueMapper: (item, _) => item,
                    yValueMapper: (item, index) {
                      if (groupedhistories[item] != null && groupedhistories[item].length > i && groupedhistories[item][i] != null && groupedhistories[item][i].endTime != null) {
                        int tomatoWorkTime = groupedhistories[item][i].endTime.millisecondsSinceEpoch - groupedhistories[item][i].startTime?.millisecondsSinceEpoch;
                        return (tomatoWorkTime / (1000 * 60)).ceil();
                      } else {
                        return null;
                      }
                    },
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
