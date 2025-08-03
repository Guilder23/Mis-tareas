// widgets/task_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../models/task.dart';
import '../screens/add_edit_task_screen.dart';
import '../utils/database_helper.dart';
import './status_chip.dart'; // Agregar esta importación

class TaskItem extends StatelessWidget {
  final Task task;
  final Function() onTaskUpdated;

  const TaskItem({Key? key, required this.task, required this.onTaskUpdated})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideInLeft(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, const Color(0xFFFCE4EC).withOpacity(0.3)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFAD1457),
                        ),
                      ),
                    ),
                    StatusChip(status: task.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color:
                          task.dueDate.isBefore(DateTime.now())
                              ? const Color(0xFFE91E63)
                              : const Color(0xFFAD1457),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd/MM/yyyy').format(task.dueDate),
                      style: TextStyle(
                        color:
                            task.dueDate.isBefore(DateTime.now())
                                ? const Color(0xFFE91E63)
                                : const Color(0xFFAD1457),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditTaskScreen(task: task),
                          ),
                        ).then((value) => onTaskUpdated());
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFFAD1457),
                        size: 20,
                      ),
                      label: const Text(
                        "Editar",
                        style: TextStyle(color: Color.fromARGB(255, 231, 93, 149)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _showDeleteConfirmation(context),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFE91E63),
                        size: 20,
                      ),
                      label: const Text(
                        "Eliminar",
                        style: TextStyle(color: Color(0xFFE91E63)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            '¿Eliminar tarea? 🥺',
            style: TextStyle(
              color: Color(0xFFAD1457),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '¿Estás segura de que quieres eliminar esta tarea, cariño? Esta acción no se puede deshacer.',
            style: TextStyle(color: Colors.grey),
          ),
          backgroundColor: Colors.white,
          elevation: 4,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar 💕',
                style: TextStyle(color: Color(0xFFAD1457)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await DatabaseHelper().deleteTask(task.id!);
                  Navigator.pop(context);
                  onTaskUpdated();
                },
                child: const Text(
                  'Eliminar 🗑️',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
