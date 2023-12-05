import 'package:cloud_firestore/cloud_firestore.dart';

class GoldMovieModel {
  String id;
  String title;
  String moviesUrl;

  GoldMovieModel({
    required this.id,
    required this.title,
    required this.moviesUrl,
  });
  static Future<void> addGoldMovie(GoldMovieModel addGoldMovie) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('gold_movies');
    Map<String, dynamic> data = {
      'id': addGoldMovie.id,
      'title': addGoldMovie.title,
      'moviesUrl': addGoldMovie.moviesUrl,
    };
    await db.add(data);
  }

  static Future<void> updateGoldMovie(
      String id, GoldMovieModel updateGoldMovie) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('gold_movies');

    Map<String, dynamic> data = {
      'id': updateGoldMovie.id,
      'title': updateGoldMovie.title,
      'moviesUrl': updateGoldMovie.moviesUrl,
    };
    await db.doc(id).update(data);
  }

  static Future<void> deleteGoldMovie(String id) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('gold_movies');

    await db.doc(id).delete();
  }
}
