class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final String? assignedTo;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.assignedTo,
  });

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id ?? "Error",
      title: map['title'] ?? "Error",
      description: map['description'] ?? "Error",
      status: map['status'] ?? "Error",
      assignedTo: map['assignedTo'] ?? "Error",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'assignedTo': assignedTo,
    };
  }
}
