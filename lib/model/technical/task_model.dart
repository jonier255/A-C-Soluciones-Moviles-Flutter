class TaskModel {
  final String title;
  final String location;
  final String date;
  final String status;

  TaskModel({
    required this.title,
    required this.location,
    required this.date,
    required this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'] ?? 'Sin título',
      location: json['location'] ?? 'Sin ubicación',
      date: json['date'] ?? 'Sin fecha',
      status: json['status'] ?? 'Desconocido',
    );
  }
}