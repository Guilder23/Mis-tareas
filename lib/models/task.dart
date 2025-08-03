// models/task.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TaskStatus { pending, inProgress, completed }

class Task {
  int? id;
  String title;
  String description;
  DateTime dueDate;
  TaskStatus status;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.status = TaskStatus.pending,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status.index,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      status: TaskStatus.values[map['status']],
    );
  }

  String get statusLabel {
    switch (status) {
      case TaskStatus.pending:
        return "Pendiente";
      case TaskStatus.inProgress:
        return "En Ejecución";
      case TaskStatus.completed:
        return "Terminado";
    }
  }

  Color get statusColor {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
    }
  }
}
