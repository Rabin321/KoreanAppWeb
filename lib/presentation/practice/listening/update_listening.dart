import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:korean_app_web/presentation/practice/listening/update_complete_listening.dart';

import '../../../utils/app_colors.dart';
import 'listening_model.dart';

class UpdateListening extends StatelessWidget {
  static const String id = "updatelistening";

  const UpdateListening({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "UPDATE LISTENING",
              //style: EcoStyle.boldStyle,
            ),
            Expanded(
              child: Container(
                width: double.infinity, // Set width to maximum available width
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('practice_listening')
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
                        DataColumn(label: Text('Audio Title')),
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
                                        PracticeListeningModel
                                            .deletePracticeListening(
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
                                              UpdateCompleteListening(
                                            id: data[index].id,
                                            practiceListeningModel:
                                                PracticeListeningModel(
                                              id: id,
                                              title: data[index]['title'],
                                              audioUrl: data[index]['audioUrl'],
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
