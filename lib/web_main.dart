import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:korean_app_web/presentation/dashboard/dashboard_screen.dart';
import 'package:korean_app_web/presentation/practice/listening/add_listening.dart';
import 'package:korean_app_web/utils/app_colors.dart';

// import 'deleteProducts_screen.dart';

class WebMainScreen extends StatefulWidget {
  // const WebMainScreen({Key? key}) : super(key: key);
  static const String id = "webmain";

  // final String subResourceName; // Add this line

  const WebMainScreen({Key? key}) : super(key: key);

  @override
  State<WebMainScreen> createState() => _WebMainScreenState();
}

class _WebMainScreenState extends State<WebMainScreen> {
  Widget selectedSCreen = const DashBoardScreen();

  chooseScreens(item) {
    switch (item.route) {
      //
      case DashBoardScreen.id:
        setState(() {
          selectedSCreen = const DashBoardScreen();
        });
        break;
      case AddQuiz.id:
        setState(() {
          selectedSCreen = const AddQuiz();
        });
        break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("ADMIN"),
        ),
        sideBar: customSideBar(),
        body: selectedSCreen);
  }

  SideBar customSideBar() {
    return SideBar(
        backgroundColor: AppColors.primary,
        textStyle: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
        onSelected: (item) {
          chooseScreens(item);
        },
        items: [
          AdminMenuItem(
            title: "DASHBOARD",
            icon: Icons.dashboard,
            route: DashBoardScreen.id,
          ),
          AdminMenuItem(title: "PRACTICE", icon: Icons.dashboard, children: [
            AdminMenuItem(
              title: "LISTENING",
              icon: Icons.dashboard,
              route: AddQuiz.id,
            ),
          ]),
        ],
        selectedRoute: WebMainScreen.id);
  }
}
