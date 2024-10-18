import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() {
  runApp(TaskPlannerApp());
}

class TaskPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskPlannerScreen(),
    );
  }
}

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

  List<Task> filteredTasks = []; // Menyimpan tugas yang sudah difilter
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Kuliah';

  // Notifikasi timer
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
    // Inisialisasi dengan semua tugas
    filteredTasks = List.from(tasks);
    _sortTasks(); // Menyortir tugas saat inisialisasi
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
              // Header
              _buildHeader(),
              SizedBox(height: 20),
              // Task Target with Progress Bar
              _buildTaskTarget(),
              SizedBox(height: 20),
              // Category Section
              _buildCategorySection(),
              SizedBox(height: 20),
              // Task Priority Section
              _buildTaskPrioritySection(),
              SizedBox(height: 20),
              // Add New Task Button
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

  // Header widget
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

  // Task Target with progress
// Task Target with progress
Widget _buildTaskTarget() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8), // Kotak putih dengan transparansi
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5, spreadRadius: 1),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Judul untuk Task Target dengan ikon lonceng
              Text(
                'Task Target',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.notifications, color: Colors.grey), // Tambahkan ikon lonceng di sini
            ],
          ),
          SizedBox(height: 8),
          Text(
            'One step at a time. You\'ll get there.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text('Tugas Modul Statistika Industri'),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: taskProgress,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
          SizedBox(height: 8),
          Text('${(taskProgress * 100).toInt()}%'),
        ],
      ),
    ),
  );
}


  // Category Section
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
        SizedBox(height: 10), // Jarak di atas kategori
        DropdownButton<String>(
          value: _selectedCategory,
          items: <String>['Kuliah', 'Organisasi', 'Lab']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue!;
              // Filter tasks by selected category
              filteredTasks = tasks.where((task) => task.category == _selectedCategory).toList();
              _sortTasks(); // Urutkan tugas setelah memfilter
            });
          },
        ),
        SizedBox(height: 10), // Ubah jarak di bawah kategori di sini
      ],
    );
  }

  // Task Priority Section with Task List
// Task Priority Section with Task List
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
              Icon(Icons.notifications, color: Colors.grey), // Tambahkan ikon lonceng di sini
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
          ListView.builder(
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
                    filteredTasks.removeAt(index);
                    tasks.removeWhere((task) => task.title == filteredTasks[index].title); // Menghapus dari daftar asli
                  });
                },
                onEdit: (updatedTask) {
                  setState(() {
                    filteredTasks[index] = updatedTask; // Update filtered task
                    tasks[tasks.indexOf(filteredTasks[index])] = updatedTask; // Update dari daftar asli
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


  // Filter Task Dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Tasks'),
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

  // Task filter function
  void _filterTasks(String priority) {
    setState(() {
      filteredTasks = tasks.where((task) => task.priority == priority && task.category == _selectedCategory).toList();
      _sortTasks(); // Urutkan tugas setelah memfilter
    });
  }

  // Statistics Dialog
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  // Add new task dialog
  Future<void> _addNewTask() async {
    _taskController.clear();
    _priorityController.clear();
    _selectedDate = DateTime.now();
    String newPriority = 'Tinggi'; // Default priority

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Tugas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: InputDecoration(labelText: 'Judul Tugas'),
              ),
              DropdownButton<String>(
                value: newPriority,
                items: <String>['Tinggi', 'Sedang', 'Rendah']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    newPriority = newValue!;
                  });
                },
              ),
              TextButton(
                onPressed: _selectDate,
                child: Text('Pilih Deadline'),
              ),
              Text('Tanggal: ${DateFormat.yMMMd().format(_selectedDate)}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Task newTask = Task(
                    _taskController.text,
                    newPriority,
                    false,
                    _selectedDate,
                    _selectedCategory,
                  );
                  tasks.add(newTask);
                  filteredTasks = List.from(tasks.where((task) => task.category == _selectedCategory)); // Update filtered tasks
                  _sortTasks(); // Urutkan tugas setelah menambah
                  _taskController.clear();
                  _priorityController.clear();
                  _selectedCategory = 'Kuliah'; // reset ke default
                  _selectedDate = DateTime.now();
                });
                Navigator.of(context).pop();
              },
              child: Text('Tambah Tugas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  // Sort tasks by deadline
  void _sortTasks() {
    filteredTasks.sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  // Date picker for selecting deadline
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

// Task class
class Task {
  String title;
  String priority;
  bool isDone;
  DateTime deadline;
  String category;

  Task(this.title, this.priority, this.isDone, this.deadline, this.category);
}

// Task Item widget
class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDelete; // Tambahkan callback untuk delete
  final ValueChanged<Task> onEdit; // Tambahkan callback untuk edit

  const TaskItem({
    Key? key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        'Prioritas: ${task.priority} | Deadline: ${DateFormat.yMMMd().format(task.deadline)} | Kategori: ${task.category}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: task.isDone,
            onChanged: onChanged,
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String value) {
              if (value == 'Edit') {
                _showEditDialog(context); // Tampilkan dialog edit
              } else if (value == 'Delete') {
                onDelete(); // Panggil fungsi delete
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Edit',
                  child: Text('Edit Task'),
                ),
                PopupMenuItem<String>(
                  value: 'Delete',
                  child: Text('Delete Task'),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final TextEditingController _titleController = TextEditingController(text: task.title);
    final TextEditingController _priorityController = TextEditingController(text: task.priority);
    DateTime _selectedDate = task.deadline;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Judul Tugas'),
              ),
              DropdownButton<String>(
                value: _priorityController.text,
                items: <String>['Tinggi', 'Sedang', 'Rendah']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  _priorityController.text = newValue!;
                },
              ),
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    _selectedDate = pickedDate;
                  }
                },
                child: Text('Pilih Deadline'),
              ),
              Text('Tanggal: ${DateFormat.yMMMd().format(_selectedDate)}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Update task
                final updatedTask = Task(
                  _titleController.text,
                  _priorityController.text,
                  task.isDone,
                  _selectedDate,
                  task.category,
                );
                onEdit(updatedTask); // Panggil fungsi edit
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }
}


