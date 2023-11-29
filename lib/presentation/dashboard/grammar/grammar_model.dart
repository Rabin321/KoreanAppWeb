// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class GrammarWordModel {
  String id;
  String word;

  String kDetail;
  String kExample;

  String nDetail;
  String nExample;
  String eDetail;
  String eExample;

  GrammarWordModel({
    required this.id,
    required this.word,
    required this.kDetail,
    required this.kExample,
    required this.nDetail,
    required this.nExample,
    required this.eDetail,
    required this.eExample,
  });

  static Future<void> addGrammarWord(GrammarWordModel addGrammarWord) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('GrammarWord');
    Map<String, dynamic> data = {
      'id': addGrammarWord.id, // 'id': lifeSkills.id,
      'word': addGrammarWord.word,
      'kDetail': addGrammarWord.kDetail,
'kExample': addGrammarWord.kExample,
      'nDetail': addGrammarWord.nDetail,
      'nExample': addGrammarWord.nExample,
      'eDetail': addGrammarWord.eDetail,
      'eExample': addGrammarWord.eExample,
    };
    await db.add(data);
  }

  static Future<void> updateGrammarWord(
      String id, GrammarWordModel updateGrammarWord) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('GrammarWord');

    Map<String, dynamic> data = {
      'id': updateGrammarWord.id, // 'id': lifeSkills.id,
      'word': updateGrammarWord.word,
      'kDetail': updateGrammarWord.kDetail,
      'kExample': updateGrammarWord.kExample,
      'nDetail': updateGrammarWord.nDetail,
      'nExample': updateGrammarWord.nExample,
      'eDetail': updateGrammarWord.eDetail,
      'eExample': updateGrammarWord.eExample,
    };
    await db.doc(id).update(data);
  }

  static Future<void> deleteGrammarWord(String id) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('GrammarWord');

    await db.doc(id).delete();
  }
}
