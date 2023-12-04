import 'package:cloud_firestore/cloud_firestore.dart';

class PracticeSocializationModel {
  String id;
  String title;
  String imageUrl;
  // String title;

  List<dynamic> options;
  // String questionimage;
  String correctAnswer;

  PracticeSocializationModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.options,
    required this.correctAnswer,
  });

  static Future<void> addPracticeSocialization(
      PracticeSocializationModel addPracticeSocialization) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('practice_socialization');
    Map<String, dynamic> data = {
      'id': addPracticeSocialization.id,
      // 'title': addPracticeListening.title,
      'correctAnswer': addPracticeSocialization.correctAnswer,
      'options': addPracticeSocialization.options,
      'title': addPracticeSocialization.title,
      'imageUrl': addPracticeSocialization.imageUrl,
    };
    await db.add(data);
  }

  static Future<void> updatePracticeSocialization(
      String id, PracticeSocializationModel updatePracticeSocialization) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('practice_socialization');
    Map<String, dynamic> data = {
      'id': updatePracticeSocialization.id,
      // 'title': updatePracticeListening.title,
      'correctAnswer': updatePracticeSocialization.correctAnswer,
      'options': updatePracticeSocialization.options,
      'title': updatePracticeSocialization.title,
      'imageUrl': updatePracticeSocialization.imageUrl,
    };
    await db.doc(id).update(data);
  }

  static Future<void> deletePracticeSocialization(String id) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('practice_socialization');
    await db.doc(id).delete();
  }
}
