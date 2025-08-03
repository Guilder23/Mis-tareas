// screens/add_edit_task_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../utils/database_helper.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate;
  late TaskStatus _status;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _dueDate = widget.task?.dueDate ?? DateTime.now();
    _status = widget.task?.status ?? TaskStatus.pending;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _getStatusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return "Pendiente";
      case TaskStatus.inProgress:
        return "En Ejecución";
      case TaskStatus.completed:
        return "Terminado";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null
              ? 'Creando nueva tarea Mi vida❤️'
              : 'Estas editando tarea Cariño😊',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE91E63), // Rosa
                Color(0xFFAD1457), // Rosa oscuro
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFCE4EC), // Rosa muy claro
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Card(
                  elevation: 8,
                  shadowColor: Colors.pink.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          const Color(0xFFFCE4EC).withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Título 💝',
                              labelStyle: TextStyle(color: Color(0xFFAD1457)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Color(0xFFE91E63),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Color(0xFFE91E63),
                                  width: 2,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.title,
                                color: Color(0xFFE91E63),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Descripción 💖',
                              labelStyle: TextStyle(color: Color(0xFFAD1457)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Color(0xFFE91E63),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Color(0xFFE91E63),
                                  width: 2,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.description,
                                color: Color(0xFFE91E63),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              picker.DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime(2030),
                                onConfirm:
                                    (date) => setState(() => _dueDate = date),
                                currentTime: _dueDate,
                                locale: picker.LocaleType.es,
                                theme: picker.DatePickerTheme(
                                  // Usar el prefijo picker aquí
                                  backgroundColor: Colors.white,
                                  itemStyle: const TextStyle(
                                    color: Color(0xFFAD1457),
                                  ),
                                  doneStyle: const TextStyle(
                                    color: Color(0xFFE91E63),
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFE91E63)),
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFFE91E63),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Fecha Límite: ${DateFormat('dd/MM/yyyy').format(_dueDate)} 📅',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFAD1457),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              border: Border.all(color: Color(0xFFE91E63)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<TaskStatus>(
                                value: _status,
                                isExpanded: true,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                items:
                                    TaskStatus.values.map((status) {
                                      return DropdownMenuItem(
                                        value: status,
                                        child: Row(
                                          children: [
                                            Icon(
                                              status == TaskStatus.completed
                                                  ? Icons.check_circle
                                                  : status ==
                                                      TaskStatus.inProgress
                                                  ? Icons.pending
                                                  : Icons.schedule,
                                              color: Color(0xFFE91E63),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              _getStatusLabel(status),
                                              style: const TextStyle(
                                                color: Color(0xFFAD1457),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                onChanged:
                                    (value) => setState(() => _status = value!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: _saveTask,
                    child: Text(
                      widget.task == null
                          ? 'Crear Tarea ✨'
                          : 'Actualizar Tarea 💫',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: widget.task?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        status: _status,
      );

      if (widget.task == null) {
        await DatabaseHelper().insertTask(task);
      } else {
        await DatabaseHelper().updateTask(task);
      }

      Navigator.pop(context);
    }
  }
}
