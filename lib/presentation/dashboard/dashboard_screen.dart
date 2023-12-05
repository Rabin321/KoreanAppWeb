import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:korean_app_web/presentation/dashboard/users/user_list.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';

class DashBoardScreen extends StatefulWidget {
  static const String id = "dashboard";

  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

// ...

class _DashBoardScreenState extends State<DashBoardScreen> {
  int userCount = 0; // New variable to store user count

  @override
  void initState() {
    super.initState();
    // Call a function to fetch user count when the screen initializes
    fetchUserCount();
  }

  Future<void> fetchUserCount() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users') // replace with your collection name
              .get();

      setState(() {
        userCount = snapshot.size;
      });
    } catch (e) {
      print('Error fetching user count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive values
    final containerWidth = screenWidth * 0.2;
    final containerHeight = screenHeight * 0.25;
    final paddingVertical = screenHeight * 0.02;
    final paddingHorizontal = screenWidth * 0.05;
    final iconSize = screenWidth * 0.035;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 5.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserListPage()),
                    );
                  },
                  child: Container(
                    width: containerWidth,
                    height: containerHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: containerWidth * 0.01,
                          blurRadius: containerWidth * 0.02,
                          offset: Offset(0, containerWidth * 0.005),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$userCount",
                            style: TextStyle(
                              fontSize: containerWidth * 0.1,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Total Users",
                            style: TextStyle(
                              fontSize: containerWidth * 0.05,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
