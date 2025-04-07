import 'package:flutter/material.dart';
import 'package:internship_task/screens/addtask_screen.dart';
import 'package:internship_task/service/firebase_service.dart';
import 'package:internship_task/widgets/task_card.dart';
import '../models/task_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final FirestoreService _service = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final statuses = ['Pending', 'Running', 'Testing', 'Completed'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTaskScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Row(
            children:
                statuses.map((status) {
                  return DragTarget<Task>(
                    onWillAccept: (task) => task!.status != status,
                    onAccept: (task) {
                      _service.updateTaskStatus(task.id, status);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Moved to $status')),
                      );
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        margin: const EdgeInsets.only(right: 10.0),
                        decoration: BoxDecoration(
                          color:
                              candidateData.isNotEmpty
                                  ? Colors.blue[100]
                                  : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                status,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Divider(thickness: 4, color: Colors.red),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: StreamBuilder<List<Task>>(
                                stream: _service.getTasksByStatus(status),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return const Center(
                                      child: Text('Something went wrong'),
                                    );
                                  }
                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                      child: Text('No tasks left'),
                                    );
                                  }

                                  final tasks = snapshot.data!;
                                  return ListView.builder(
                                    itemCount: tasks.length,
                                    itemBuilder:
                                        (_, i) => Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Draggable<Task>(
                                            data: tasks[i],
                                            feedback: Material(
                                              color: Colors.transparent,
                                              elevation: 6,
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.5,
                                                ),
                                                child: TaskCard(task: tasks[i]),
                                              ),
                                            ),

                                            childWhenDragging: Opacity(
                                              opacity: 0.3,
                                              child: TaskCard(task: tasks[i]),
                                            ),
                                            child: TaskCard(task: tasks[i]),
                                          ),
                                        ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
