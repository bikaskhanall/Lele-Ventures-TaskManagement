import 'package:flutter/material.dart';
import 'package:internship_task/service/firebase_service.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final FirestoreService _service = FirestoreService();

  TaskCard({super.key, required this.task});

  void _moveToNextStage(BuildContext context) {
    final current = task.status;
    final next =
        {
          'Pending': 'Running',
          'Running': 'Testing',
          'Testing': 'Completed',
          'Completed': null,
        }[current];

    if (next != null) {
      _service.updateTaskStatus(task.id, next);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Moved to $next stage')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.task_alt, color: Colors.blueAccent.shade200, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (task.assignedTo != null)
                    Text(
                      'Assigned to: ${task.assignedTo}',
                      style: const TextStyle(fontSize: 13, color: Colors.red),
                    ),
                ],
              ),
            ),
            if (task.status != 'Completed')
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 20),
                onPressed: () => _moveToNextStage(context),
              ),
          ],
        ),
      ),
    );
  }
}
