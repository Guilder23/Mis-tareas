// widgets/status_chip.dart
import 'package:flutter/material.dart';
import '../models/task.dart';

class StatusChip extends StatelessWidget {
  final TaskStatus status;

  const StatusChip({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    switch (status) {
      case TaskStatus.pending:
        label = "Pendiente";
        color = Colors.orange;
        break;
      case TaskStatus.inProgress:
        label = "En Ejecución";
        color = Colors.blue;
        break;
      case TaskStatus.completed:
        label = "Terminado";
        color = Colors.green;
        break;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 6),
    );
  }
}