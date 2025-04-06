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
    final screenHeight = MediaQuery.of(context).size.height;

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
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    margin: const EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
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
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text('No tasks Left'),
                                );
                              }

                              final tasks = snapshot.data!;
                              return ListView.builder(
                                itemCount: tasks.length,
                                itemBuilder:
                                    (_, i) => Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: TaskCard(task: tasks[i]),
                                    ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
