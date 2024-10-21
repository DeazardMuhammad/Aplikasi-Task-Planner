import 'package:flutter/material.dart';

class TaskTarget extends StatelessWidget {
  final double taskProgress;

  const TaskTarget({Key? key, required this.taskProgress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
