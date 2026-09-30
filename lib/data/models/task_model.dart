import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../domain/entities/task.dart';

class TaskModel extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;

  const TaskModel({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'] as String,
        title: json['title'] as String,
        isCompleted: json['isCompleted'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
      };

  Task toDomain() => Task(id: id, title: title, isCompleted: isCompleted);

  factory TaskModel.fromDomain(Task task) => TaskModel(
        id: task.id,
        title: task.title,
        isCompleted: task.isCompleted,
      );

  @override
  List<Object?> get props => [id, title, isCompleted];
}
