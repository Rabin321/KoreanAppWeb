import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:korean_app_web/presentation/dashboard/dashboard_screen.dart';
import 'package:korean_app_web/presentation/dashboard/grammar/add_grammar_page.dart';
import 'package:korean_app_web/presentation/dashboard/grammar/update_grammar.dart';
import 'package:korean_app_web/presentation/practice/listening/add_listening.dart';
import 'package:korean_app_web/presentation/practice/listening/update_listening.dart';
import 'package:korean_app_web/presentation/practice/reading/add_reading.dart';
import 'package:korean_app_web/presentation/practice/reading/update_reading.dart';
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
      case AddListening.id:
        setState(() {
          selectedSCreen = const AddListening();
        });
        break;
      case UpdateListening.id:
        setState(() {
          selectedSCreen = const UpdateListening();
        });
        break;

      case AddReading.id:
        setState(() {
          selectedSCreen = const AddReading();
        });
        break;

      case UpdateReading.id:
        setState(() {
          selectedSCreen = const UpdateReading();
        });
        break;
      case AddGrammar.id:
        setState(() {
          selectedSCreen = const AddGrammar();
        });
        break;

      case UpdateGrammar.id:
        setState(() {
          selectedSCreen = const UpdateGrammar();
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
            AdminMenuItem(title: "LISTENING", icon: Icons.dashboard, children: [
              AdminMenuItem(
                title: "ADD LISTENING",
                icon: Icons.dashboard,
                route: AddListening.id,
              ),
              AdminMenuItem(
                title: "UPDATE LISTENING",
                icon: Icons.dashboard,
                route: UpdateListening.id,
              ),
            ]),
            AdminMenuItem(title: "READING", icon: Icons.dashboard, children: [
              AdminMenuItem(
                title: "ADD READING",
                icon: Icons.dashboard,
                route: AddReading.id,
              ),
              AdminMenuItem(
                title: "UPDATE READING",
                icon: Icons.dashboard,
                route: UpdateReading.id,
              ),
            ]),
          ]),
          AdminMenuItem(title: "GRAMMAR", icon: Icons.book, children: [
            AdminMenuItem(
                title: "ADD GRAMMAR", icon: Icons.book, route: AddGrammar.id),
            AdminMenuItem(
                title: "UPDATE GRAMMAR",
                icon: Icons.book,
                route: UpdateGrammar.id),
          ]),
        ],
        selectedRoute: WebMainScreen.id);
  }
}
