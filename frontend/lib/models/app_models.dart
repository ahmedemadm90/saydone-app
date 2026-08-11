class SayDoneUser {
  const SayDoneUser({required this.id, required this.name, required this.email, required this.role, this.dailyCount = 0});
  final int id;
  final String name;
  final String email;
  final String role;
  final int dailyCount;

  bool get isAdmin => role == 'admin';

  factory SayDoneUser.fromJson(Map<String, dynamic> json) => SayDoneUser(
        id: int.tryParse(json['id'].toString()) ?? 0,
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        role: json['role'] as String? ?? 'user',
        dailyCount: int.tryParse(json['daily_tasks_count']?.toString() ?? '0') ?? 0,
      );
}

class SayDoneTask {
  const SayDoneTask({required this.id, required this.title, this.description, required this.status, required this.priority, this.transcription, this.createdAt});
  final int id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final String? transcription;
  final DateTime? createdAt;

  bool get isCompleted => status == 'completed';

  factory SayDoneTask.fromJson(Map<String, dynamic> json) => SayDoneTask(
        id: int.tryParse(json['id'].toString()) ?? 0,
        title: json['title'] as String? ?? 'New task',
        description: json['description'] as String?,
        status: json['status'] as String? ?? 'pending',
        priority: json['priority'] as String? ?? 'medium',
        transcription: json['transcription'] as String?,
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      );
}
