// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/task_item.dart';
import '../utils/database_helper.dart';
import '../models/task.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // Agregar constructor constante

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  TaskStatus? statusFilter;
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _searchController.addListener(_filterTasks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTasks() {
    setState(() {
      filteredTasks =
          tasks.where((task) {
            final searchMatch =
                task.title.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                task.description.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                );
            final statusMatch =
                statusFilter == null || task.status == statusFilter;
            return searchMatch && statusMatch;
          }).toList();

      if (isAscending) {
        filteredTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      } else {
        filteredTasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
      }
    });
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await DatabaseHelper().getTasks();
    setState(() {
      tasks = loadedTasks;
      isLoading = false;
      _filterTasks();
    });
  }

  void _refreshTasks() {
    setState(() {
      isLoading = true;
    });
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tus tareas MI ADA 💖'),
        elevation: 0,
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
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Barra de búsqueda y filtros
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Buscar tarea... ',
                                border: InputBorder.none,
                                icon: Icon(
                                  Icons.search,
                                  color: Color(0xFFE91E63),
                                ),
                              ),
                            ),
                          ),
                          // Filtro de estado
                          PopupMenuButton<TaskStatus?>(
                            icon: const Icon(
                              Icons.filter_list,
                              color: Color(0xFFE91E63),
                            ),
                            tooltip: 'Filtrar por estado',
                            onSelected: (TaskStatus? status) {
                              setState(() {
                                statusFilter = status;
                                _filterTasks();
                              });
                            },
                            itemBuilder:
                                (BuildContext context) => [
                                  const PopupMenuItem(
                                    value: null,
                                    child: Text('Todos 📝'),
                                  ),
                                  PopupMenuItem(
                                    value: TaskStatus.pending,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.schedule,
                                          color: Color(0xFFE91E63),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('Pendiente'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: TaskStatus.inProgress,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.pending,
                                          color: Color(0xFFE91E63),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('En Ejecución'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: TaskStatus.completed,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Color(0xFFE91E63),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('Terminado'),
                                      ],
                                    ),
                                  ),
                                ],
                          ),
                          // Filtro de orden
                          IconButton(
                            icon: Icon(
                              isAscending
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: Color(0xFFE91E63),
                            ),
                            tooltip: 'Ordenar por fecha',
                            onPressed: () {
                              setState(() {
                                isAscending = !isAscending;
                                _filterTasks();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lista de tareas
          Expanded(
            child: Container(
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
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFE91E63),
                        ),
                      )
                      : filteredTasks.isEmpty
                      ? FadeInLeft(
                        duration: const Duration(milliseconds: 800),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.task_alt,
                                size: 80,
                                color: Color(0xFFE91E63),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No se encontraron tareas 💝',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFAD1457),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : RefreshIndicator(
                        color: const Color(0xFFE91E63),
                        onRefresh: _loadTasks,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return TaskItem(
                              task: task,
                              onTaskUpdated: _refreshTasks,
                            );
                          },
                        ),
                      ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEditTaskScreen(),
              ),
            ).then((value) => _refreshTasks());
          },
          icon: const Icon(Icons.add),
          label: const Text('Nueva Tarea 💝'),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
