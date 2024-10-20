import 'package:flutter/material.dart';

class TaskTarget extends StatelessWidget {
  final double taskProgress;

  const TaskTarget({Key? key, required this.taskProgress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Progress',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: taskProgress,
          backgroundColor: Colors.grey[300],
          color: Colors.green,
        ),
        SizedBox(height: 5),
        Text(
          '${(taskProgress * 100).round()}% completed',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
