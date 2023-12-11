import 'package:cloud_firestore/cloud_firestore.dart';

class GoldBooksModel {
  String id;
  String title;
  String? booksUrl;
  String? bookFile;

  GoldBooksModel({
    required this.id,
    required this.title,
    this.booksUrl,
    this.bookFile,
  });
  static Future<void> addGoldBooks(GoldBooksModel addGoldBooks) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('gold_books');
    Map<String, dynamic> data = {
      'id': addGoldBooks.id,
      'title': addGoldBooks.title,
      'booksUrl': addGoldBooks.booksUrl,
      'bookFile': addGoldBooks.bookFile,
    };
    await db.add(data);
  }

  static Future<void> updateGoldBooks(
      String id, GoldBooksModel updateGoldBooks) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('gold_books');

    Map<String, dynamic> data = {
      'id': updateGoldBooks.id,
      'title': updateGoldBooks.title,
      'booksUrl': updateGoldBooks.booksUrl,
      'bookFile': updateGoldBooks.bookFile,
    };
    await db.doc(id).update(data);
  }

  static Future<void> deleteGoldBooks(String id) async {
    CollectionReference db =
        FirebaseFirestore.instance.collection('gold_books');

    await db.doc(id).delete();
  }
}
