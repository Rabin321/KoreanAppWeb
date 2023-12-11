import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:korean_app_web/packages/gold/books/gold_books_model.dart';
import 'package:korean_app_web/packages/gold/books/update_complete_gold_books.dart';
import 'package:korean_app_web/packages/gold/songs/gold_songs_model.dart';
import 'package:korean_app_web/packages/gold/songs/update_complete_songs.dart';
import 'package:korean_app_web/presentation/practice/listening/update_complete_listening.dart';

class UpdateGoldBooks extends StatelessWidget {
  static const String id = "updategoldbooks";

  const UpdateGoldBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "UPDATE GOLD BOOKS",
              //style: EcoStyle.boldStyle,
            ),
            Expanded(
              child: Container(
                width: double.infinity, // Set width to maximum available width
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('gold_books')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data == null) {
                      return const Center(child: Text("NO DATA EXISTS"));
                    }
                    final data = snapshot.data!.docs;

                    return DataTable(
                      // dataRowHeight: 90,
                      columnSpacing: 200.w,
                      columns: const [
                        DataColumn(label: Text('Book Title')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: List<DataRow>.generate(
                        snapshot.data!.docs.length,
                        (index) => DataRow(
                          cells: [
                            DataCell(
                              Text(data[index]['title']),
                            ),
                            DataCell(
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      onPressed: () {
                                        GoldBooksModel.deleteGoldBooks(
                                            data[index].id);
                                      },
                                      child: Text("Delete")),
                                  // IconButton(
                                  //   onPressed: () {
                                  //     PracticeListeningModel
                                  //         .deletePracticeListening(
                                  //             data[index].id);
                                  //   },
                                  //   icon: const Icon(Icons.delete_forever),
                                  //   color: AppColors.primary,
                                  // ),

                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              UpdateCompleteGoldBooks(
                                            id: data[index].id,
                                            goldbooksModel: GoldBooksModel(
                                              id: id,
                                              title: data[index]['title'],
                                              booksUrl: data[index]['booksUrl'],
                                              bookFile: data[index]['bookFile'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text("Update")),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
