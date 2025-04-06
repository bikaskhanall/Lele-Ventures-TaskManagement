import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class FirestoreService {
  final CollectionReference _taskRef = FirebaseFirestore.instance.collection(
    'tasks',
  );

  Stream<List<Task>> getTasksByStatus(String status) {
    return _taskRef.where('status', isEqualTo: status).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map(
            (doc) => Task.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    });
  }

  Future<void> addTask(Task task) async {
    await _taskRef.add(task.toMap());
  }

  Future<void> updateTaskStatus(String id, String newStatus) async {
    await _taskRef.doc(id).update({'status': newStatus});
  }
}
