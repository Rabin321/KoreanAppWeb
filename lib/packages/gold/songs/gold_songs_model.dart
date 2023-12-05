import 'package:cloud_firestore/cloud_firestore.dart';

class GoldSongsModel {
  String id;
  String title;
  String audioUrl;
  // String? imageUrls;

  GoldSongsModel({
    required this.id,
    required this.title,
    required this.audioUrl,
    //  this.imageUrls,
  });
  static Future<void> addAudio(GoldSongsModel addAudio) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('gold_songs');
    Map<String, dynamic> data = {
      'id': addAudio.id,
      'title': addAudio.title,
      'audioUrl': addAudio.audioUrl,
      // 'imageUrls': addAudio.imageUrls,
    };
    await db.add(data);
  }

  static Future<void> updateAudio(String id, GoldSongsModel updateAudio) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('gold_songs');

    Map<String, dynamic> data = {
      'id': updateAudio.id,
      'title': updateAudio.title,
      'audioUrl': updateAudio.audioUrl,
      // 'imageUrls': updateAudio.imageUrls,
    };
    await db.doc(id).update(data);
  }

  static Future<void> deleteAudio(String id) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('gold_songs');

    await db.doc(id).delete();
  }
}
