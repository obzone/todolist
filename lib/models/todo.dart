import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable(explicitToJson: true)
class DoHistoryModel {
  DateTime startTime;
  DateTime endTime;

  int totalTime;

  DoHistoryModel({this.startTime, this.endTime, this.totalTime});

  int get surplusSeconds {
    if (startTime == null) return null;
    int surplusSeconds = totalTime - ((DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch) / 1000).floor();
    return surplusSeconds > 0 ? surplusSeconds : 0;
  }

  factory DoHistoryModel.fromJson(Map<String, dynamic> json) => _$DoHistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoHistoryModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TodoModel {
  String name;
  String remark;
  DateTime createdTime;
  DateTime updatedTime;
  bool isDone;
  String id;
  String type;

  List<DoHistoryModel> doHistories;

  DoHistoryModel get doing {
    return doHistories != null && doHistories.length > 0 ? doHistories.last : null;
  }

  TodoModel({
    this.id,
    this.name,
    this.remark,
    this.createdTime,
    this.updatedTime,
    this.type,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => _$TodoModelFromJson(json);
  Map<String, dynamic> toJson() => _$TodoModelToJson(this);
}
