import 'package:flutter/material.dart';
import 'package:internship_task/service/firebase_service.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final FirestoreService _service = FirestoreService();
  String? selectedUser;

  void _submitTask() {
    if (_titleController.text.isNotEmpty && _descController.text.isNotEmpty) {
      final task = Task(
        id: '',
        title: _titleController.text,
        description: _descController.text,
        status: 'Pending',
        assignedTo: selectedUser,
      );
      _service.addTask(task);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedUser,
              onChanged: (val) {
                setState(() {
                  selectedUser = val;
                });
              },
              items:
                  ['Ram', 'Shyam', 'Rahul', 'Bikash']
                      .map(
                        (user) =>
                            DropdownMenuItem(value: user, child: Text(user)),
                      )
                      .toList(),
              decoration: const InputDecoration(labelText: 'Assign To'),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: _submitTask,
              child: const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
