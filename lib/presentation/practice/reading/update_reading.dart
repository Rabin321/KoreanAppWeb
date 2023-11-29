import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:korean_app_web/presentation/practice/listening/update_complete_listening.dart';
import 'package:korean_app_web/presentation/practice/reading/reading_model.dart';
import 'package:korean_app_web/presentation/practice/reading/update_complete_reading.dart';

import '../../../utils/app_colors.dart';

class UpdateReading extends StatelessWidget {
  static const String id = "updatereading";

  const UpdateReading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "UPDATE READING",
              //style: EcoStyle.boldStyle,
            ),
            Expanded(
              child: Container(
                width: double.infinity, // Set width to maximum available width
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('practice_reading')
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
                        DataColumn(label: Text('Image')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: List<DataRow>.generate(
                        snapshot.data!.docs.length,
                        (index) => DataRow(
                          cells: [
                            DataCell(InkWell(
                              onTap: () {
                                _showFullScreenImage(
                                    context, data[index]['imageUrl']);
                              },
                              child: Container(
                                height: 60.h,
                                width: 60.h,
                                child: Image.network(
                                  data[index]['imageUrl'],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )),
                            DataCell(
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      onPressed: () {
                                        PracticeReadingModel
                                            .deletePracticeReading(
                                                data[index].id);
                                      },
                                      child: Text("Delete")),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              UpdateCompleteReading(
                                            id: data[index].id,
                                            practiceReadingModel:
                                                PracticeReadingModel(
                                              id: id,
                                              title: data[index]['title'],
                                              imageUrl: data[index]['imageUrl'],
                                              correctAnswer: data[index]
                                                  ['correctAnswer'],
                                              options: data[index]['options'],
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

// Function to show the image in full screen
void _showFullScreenImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop(); // Close the dialog on tap
          },
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Close the dialog on button press
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
