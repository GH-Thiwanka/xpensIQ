import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String name;
  DateTime createAt;
  DateTime updatedAt;
  bool isUpdated;

  Task({
    required this.id,
    required this.name,
    required this.createAt,
    required this.isUpdated,
    required this.updatedAt,
  });

  //metord to convert firebase document in to datr object

  factory Task.fromJson(Map<String, dynamic> doc, String id) {
    return Task(
      id: id,
      name: doc['name'],
      createAt: (doc['createAt'] as Timestamp).toDate(),
      isUpdated: doc['isUpdated'],
      updatedAt: (doc['updatedAt'] as Timestamp).toDate(),
    );
  }

  //convert the task model to firebase document

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createAt': createAt,
      'updatedAt': updatedAt,
      'isUpdated': isUpdated,
    };
  }
}
