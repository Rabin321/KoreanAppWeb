// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class PracticeListeningModel {
  String id;
  String title;
  String audioUrl;
  // String title;

  List<dynamic> options;
  // String questionimage;
  String correctAnswer;

  PracticeListeningModel({
    required this.id,
    required this.title,
    required this.audioUrl,
    required this.options,
    required this.correctAnswer,
  });

  static Future<void> addPracticeListening(
      PracticeListeningModel addPracticeListening) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('practice_listening');
    Map<String, dynamic> data = {
      'id': addPracticeListening.id,
      // 'title': addPracticeListening.title,
      'correctAnswer': addPracticeListening.correctAnswer,
      'options': addPracticeListening.options,
      'title': addPracticeListening.title,
      'audioUrl': addPracticeListening.audioUrl,
    };
    await db.add(data);
  }

  static Future<void> updatePracticeListening(
      String id, PracticeListeningModel updatePracticeListening) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('practice_listening');
    Map<String, dynamic> data = {
      'id': updatePracticeListening.id,
      // 'title': updatePracticeListening.title,
      'correctAnswer': updatePracticeListening.correctAnswer,
      'options': updatePracticeListening.options,
      'title': updatePracticeListening.title,
      'audioUrl': updatePracticeListening.audioUrl,
    };
    await db.doc(id).update(data);
  }

  static Future<void> deletePracticeListening(String id) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('practice_listening');
    await db.doc(id).delete();
  }
}
