import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDelete;
  final ValueChanged<Task> onEdit;

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
                _showEditDialog(context);
              } else if (value == 'Delete') {
                onDelete();
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
    final TextEditingController titleController = TextEditingController(text: task.title);
    String selectedPriority = task.priority;
    String selectedCategory = task.category;
    DateTime selectedDate = task.deadline;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Menggunakan StatefulBuilder untuk memperbarui state di dalam dialog
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Judul Tugas'),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Prioritas:'),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButton<String>(
                            value: selectedPriority,
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
                                  selectedPriority = newValue;
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
                            value: selectedCategory,
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
                                  selectedCategory = newValue;
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
                        DateFormat.yMMMd().format(selectedDate),
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null && pickedDate != selectedDate) {
                          setState(() {
                            selectedDate = pickedDate;
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
                    if (titleController.text.isNotEmpty) {
                      onEdit(Task(
                        titleController.text,
                        selectedPriority,
                        task.isDone,
                        selectedDate,
                        selectedCategory,
                      ));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Save Changes'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
