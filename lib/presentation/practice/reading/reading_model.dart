// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class PracticeReadingModel {
  String id;
  String title;
  String imageUrl;
  // String title;

  List<dynamic> options;
  // String questionimage;
  String correctAnswer;

  PracticeReadingModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.options,
    required this.correctAnswer,
  });

  static Future<void> addPracticeReading(
      PracticeReadingModel addPracticeReading) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('practice_reading');
    Map<String, dynamic> data = {
      'id': addPracticeReading.id,
      // 'title': addPracticeListening.title,
      'correctAnswer': addPracticeReading.correctAnswer,
      'options': addPracticeReading.options,
      'title': addPracticeReading.title,
      'imageUrl': addPracticeReading.imageUrl,
    };
    await db.add(data);
  }

  static Future<void> updatePracticeReading(
      String id, PracticeReadingModel updatePracticeReading) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('practice_reading');
    Map<String, dynamic> data = {
      'id': updatePracticeReading.id,
      // 'title': updatePracticeListening.title,
      'correctAnswer': updatePracticeReading.correctAnswer,
      'options': updatePracticeReading.options,
      'title': updatePracticeReading.title,
      'imageUrl': updatePracticeReading.imageUrl,
    };
    await db.doc(id).update(data);
  }

  static Future<void> deletePracticeReading(String id) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('practice_reading');
    await db.doc(id).delete();
  }
}
