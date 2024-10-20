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
    final TextEditingController priorityController = TextEditingController(text: task.priority);
    DateTime selectedDate = task.deadline;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Task Title'),
              ),
              DropdownButton<String>(
                value: task.priority,
                items: <String>['Tinggi', 'Sedang', 'Rendah']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  priorityController.text = newValue!;
                },
              ),
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
                    selectedDate = pickedDate;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                onEdit(Task(
                  titleController.text,
                  priorityController.text,
                  task.isDone,
                  selectedDate,
                  task.category,
                ));
                Navigator.of(context).pop();
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
  }
}
