// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoHistoryModel _$DoHistoryModelFromJson(Map<String, dynamic> json) {
  return DoHistoryModel(
    startTime: json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String),
    endTime: json['endTime'] == null
        ? null
        : DateTime.parse(json['endTime'] as String),
  );
}

Map<String, dynamic> _$DoHistoryModelToJson(DoHistoryModel instance) =>
    <String, dynamic>{
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
    };

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) {
  return TodoModel(
    id: json['id'] as String,
    name: json['name'] as String,
    remark: json['remark'] as String,
    createdTime: json['createdTime'] == null
        ? null
        : DateTime.parse(json['createdTime'] as String),
    updatedTime: json['updatedTime'] == null
        ? null
        : DateTime.parse(json['updatedTime'] as String),
  )
    ..isDone = json['isDone'] as bool
    ..type = json['type'] as String
    ..doHistories = (json['doHistories'] as List)
        ?.map((e) => e == null
            ? null
            : DoHistoryModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TodoModelToJson(TodoModel instance) => <String, dynamic>{
      'name': instance.name,
      'remark': instance.remark,
      'createdTime': instance.createdTime?.toIso8601String(),
      'updatedTime': instance.updatedTime?.toIso8601String(),
      'isDone': instance.isDone,
      'id': instance.id,
      'type': instance.type,
      'doHistories': instance.doHistories?.map((e) => e?.toJson())?.toList(),
    };
