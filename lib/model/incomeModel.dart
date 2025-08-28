import 'package:cloud_firestore/cloud_firestore.dart';

class Incomemodel {
  String id;
  String type;
  String description;
  double value;
  DateTime dateTime;

  Incomemodel({
    required this.id,
    required this.type,
    required this.description,
    required this.value,
    required this.dateTime,
  });

  factory Incomemodel.fromJson(Map<String, dynamic> doc, String id) {
    return Incomemodel(
      id: id,
      type: doc['type'],
      description: doc['description'],
      value: doc['value'],
      dateTime: (doc['dateTime'] as Timestamp).toDate(),
    );
  }

  //convert the income model to a firebase document
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'description': description,
      'value': value,
      'datetime': dateTime,
    };
  }
}
