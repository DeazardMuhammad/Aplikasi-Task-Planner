import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../models/task.dart';
import '../widgets/task_item.dart';
import '../widgets/task_target.dart';

class TaskPlannerScreen extends StatefulWidget {
  @override
  _TaskPlannerScreenState createState() => _TaskPlannerScreenState();
}

class _TaskPlannerScreenState extends State<TaskPlannerScreen> {
  double taskProgress = 0.5;
  List<Task> tasks = [
    Task('Tugas Besar Permodelan Proses Bisnis', 'Tinggi', false, DateTime.now().add(Duration(days: 3)), 'Kuliah'),
    Task('Tugas Modul Statistika Industri', 'Sedang', true, DateTime.now().add(Duration(days: 1)), 'Kuliah'),
    Task('Tugas Besar Statistika Industri', 'Tinggi', false, DateTime.now().add(Duration(days: 7)), 'Lab'),
    Task('Tugas Kepemimpinan', 'Rendah', false, DateTime.now().add(Duration(days: 5)), 'Organisasi'),
  ];

  List<Task> filteredTasks = [];
  final TextEditingController _taskController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'All';
  String _selectedPriority = 'Tinggi';

  void scheduleNotification(Task task) {
    Timer(Duration(seconds: 5), () {
      if (!task.isDone) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ingat tugas: ${task.title} hampir jatuh tempo!'),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    filteredTasks = List.from(tasks);
    _sortTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F2F1),
      appBar: AppBar(
        title: Text('Task Planner'),
        backgroundColor: Color(0xFF1F3B6C),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: Icon(Icons.pie_chart),
            onPressed: _showStatistics,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              TaskTarget(taskProgress: taskProgress),
              SizedBox(height: 20),
              _buildCategorySection(),
              SizedBox(height: 20),
              _buildTaskPrioritySection(),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton.icon(
                  onPressed: _addNewTask,
                  icon: Icon(Icons.add),
                  label: Text('Add new sub task'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/profile_picture.png'),
          radius: 30,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Deazard Muhammad A.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Undergraduate Student of Information Systems'),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        DropdownButton<String>(
          value: _selectedCategory,
          items: <String>['All', 'Kuliah', 'Organisasi', 'Lab']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue!;
              filteredTasks = _selectedCategory == 'All'
                  ? List.from(tasks)
                  : tasks.where((task) => task.category == _selectedCategory).toList();
              _sortTasks();
            });
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTaskPrioritySection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Task Priority',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.notifications, color: Colors.grey),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Be gentle with yourself.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            filteredTasks.isEmpty
                ? Text('No tasks available.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        task: filteredTasks[index],
                        onChanged: (value) {
                          setState(() {
                            filteredTasks[index].isDone = value!;
                            if (value) {
                              scheduleNotification(filteredTasks[index]);
                            }
                          });
                        },
                        onDelete: () {
                          setState(() {
                            tasks.remove(filteredTasks[index]);
                            filteredTasks.removeAt(index);
                          });
                        },
                        onEdit: (updatedTask) {
                          setState(() {
                            int taskIndex = tasks.indexOf(filteredTasks[index]);
                            if (taskIndex != -1) {
                              tasks[taskIndex] = updatedTask;
                              filteredTasks[index] = updatedTask;
                            }
                          });
                        },
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Tasks by Priority'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Prioritas Tinggi'),
                onTap: () {
                  Navigator.of(context).pop();
                  _filterTasks('Tinggi');
                },
              ),
              ListTile(
                title: Text('Prioritas Sedang'),
                onTap: () {
                  Navigator.of(context).pop();
                  _filterTasks('Sedang');
                },
              ),
              ListTile(
                title: Text('Prioritas Rendah'),
                onTap: () {
                  Navigator.of(context).pop();
                  _filterTasks('Rendah');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _filterTasks(String priority) {
    setState(() {
      filteredTasks = _selectedCategory == 'All'
          ? tasks.where((task) => task.priority == priority).toList()
          : tasks.where((task) => task.priority == priority && task.category == _selectedCategory).toList();
      _sortTasks();
    });
  }

  void _showStatistics() {
    showDialog(
      context: context,
      builder: (context) {
        int completedTasks = filteredTasks.where((task) => task.isDone).length;
        int totalTasks = filteredTasks.length;
        return AlertDialog(
          title: Text('Statistics'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Tugas: $totalTasks'),
              Text('Tugas Selesai: $completedTasks'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addNewTask() async {
    _taskController.clear();
    DateTime tempSelectedDate = DateTime.now();
    String tempSelectedPriority = 'Tinggi'; // Default priority
    String tempSelectedCategory = 'Kuliah'; // Default category

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Menggunakan StatefulBuilder untuk memperbarui state di dalam dialog
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Tambah Tugas'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _taskController,
                      decoration: InputDecoration(labelText: 'Judul Tugas'),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Prioritas:'),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButton<String>(
                            value: tempSelectedPriority,
                            items: <String>['Tinggi', 'Sedang', 'Rendah']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  tempSelectedPriority = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Kategori:'),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButton<String>(
                            value: tempSelectedCategory,
                            items: <String>['Kuliah', 'Organisasi', 'Lab']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  tempSelectedCategory = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('Select Deadline:'),
                    SizedBox(height: 10),
                    GestureDetector(
                      child: Text(
                        DateFormat.yMMMd().format(tempSelectedDate),
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: tempSelectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null && pickedDate != tempSelectedDate) {
                          setState(() {
                            tempSelectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_taskController.text.isNotEmpty) {
                      setState(() {
                        Task newTask = Task(
                          _taskController.text,
                          tempSelectedPriority,
                          false,
                          tempSelectedDate,
                          tempSelectedCategory,
                        );
                        tasks.add(newTask);
                        if (_selectedCategory == 'All' || _selectedCategory == tempSelectedCategory) {
                          filteredTasks.add(newTask);
                        }
                        _taskController.clear();
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Tambah Tugas'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Batal'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _sortTasks() {
    filteredTasks.sort((a, b) => a.deadline.compareTo(b.deadline));
  }
}
