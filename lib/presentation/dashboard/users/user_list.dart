import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:korean_app_web/utils/app_colors.dart';

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      child: Dialog(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "USER LIST",
                    //style: EcoStyle.boldStyle,
                  ),
                  SizedBox(
                    height: 300, // Set a specific height
                    child: Container(
                      width: double.infinity,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.data == null) {
                            return const Center(child: Text("NO DATA EXISTS"));
                          }
                          final data = snapshot.data!.docs;

                          if (data.isEmpty) {
                            return const Center(
                              child: Text("No users found."),
                            );
                          }

                          return DataTable(
                            columnSpacing: 100.w,
                            columns: const [
                              DataColumn(label: Text('Username')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: List<DataRow>.generate(
                              data.length,
                              (index) => DataRow(
                                cells: [
                                  DataCell(
                                    Text(data[index]['name']),
                                  ),
                                  DataCell(
                                    Text(data[index]['email']),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () {
                                            _showDeleteConfirmationDialog(
                                                context, data[index].id);
                                          },
                                          child: Text("Delete"),
                                        ),
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
          ),
        ),
      ),
    );
  }
}

Future<void> _showDeleteConfirmationDialog(
    BuildContext context, String userId) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete this user?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          TextButton(
            onPressed: () {
              _deleteUser(userId);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _deleteUser(String userId) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
    // Optional: You can add a confirmation dialog or snackbar here.
  } catch (e) {
    print('Error deleting user: $e');
    // Handle error gracefully
  }
}
