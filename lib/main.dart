import 'package:flutter/material.dart';
import 'screens/task_planner_screen.dart';

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
