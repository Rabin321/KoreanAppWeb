import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:korean_app_web/packages/gold/movies/add_gold_movies.dart';
import 'package:korean_app_web/packages/gold/movies/update_gold_movies.dart';
import 'package:korean_app_web/packages/gold/songs/add_gold_songs.dart';
import 'package:korean_app_web/packages/gold/songs/update_gold_songs.dart';
import 'package:korean_app_web/presentation/dashboard/dashboard_screen.dart';
import 'package:korean_app_web/presentation/dashboard/grammar/add_grammar_page.dart';
import 'package:korean_app_web/presentation/dashboard/grammar/update_grammar.dart';
import 'package:korean_app_web/presentation/practice/listening/add_listening.dart';
import 'package:korean_app_web/presentation/practice/listening/update_listening.dart';
import 'package:korean_app_web/presentation/practice/reading/add_reading.dart';
import 'package:korean_app_web/presentation/practice/reading/update_reading.dart';
import 'package:korean_app_web/presentation/practice/socialization/add_socialization.dart';
import 'package:korean_app_web/presentation/practice/socialization/update_socialization.dart';
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

      case AddSocialization.id:
        setState(() {
          selectedSCreen = const AddSocialization();
        });
        break;

      case UpdateSocialization.id:
        setState(() {
          selectedSCreen = UpdateSocialization();
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

      case AddGoldMovie.id:
        setState(() {
          selectedSCreen = const AddGoldMovie();
        });
        break;

      case UpdateGoldMovie.id:
        setState(() {
          selectedSCreen = const UpdateGoldMovie();
        });
        break;

      case AddGoldSongs.id:
        setState(() {
          selectedSCreen = const AddGoldSongs();
        });
        break;

      case UpdateGoldSongs.id:
        setState(() {
          selectedSCreen = const UpdateGoldSongs();
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
        backgroundColor: AppColors.white,
        textStyle: TextStyle(
            color: Color.fromARGB(255, 131, 131, 131), fontSize: 4.sp),
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
            AdminMenuItem(
                title: "SOCIALIZATION",
                icon: Icons.dashboard,
                children: [
                  AdminMenuItem(
                    title: "ADD SOCIALIZATION",
                    icon: Icons.dashboard,
                    route: AddSocialization.id,
                  ),
                  AdminMenuItem(
                    title: "UPDATE SOCIALIZATION",
                    icon: Icons.dashboard,
                    route: UpdateSocialization.id,
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
          AdminMenuItem(title: "PACKAGES", icon: Icons.book, children: [
            AdminMenuItem(title: "GOLD", icon: Icons.book, children: [
              AdminMenuItem(title: "MOVIES", icon: Icons.book, children: [
                AdminMenuItem(
                    title: "ADD MOVIES",
                    icon: Icons.book,
                    route: AddGoldMovie.id),
                AdminMenuItem(
                    title: "UPDATE MOVIES",
                    icon: Icons.book,
                    route: UpdateGoldMovie.id),
              ]),
              AdminMenuItem(title: "SONGS", icon: Icons.book, children: [
                AdminMenuItem(
                    title: "ADD SONGS",
                    icon: Icons.book,
                    route: AddGoldSongs.id),
                AdminMenuItem(
                    title: "UPDATE SONGS",
                    icon: Icons.book,
                    route: UpdateGoldSongs.id),
              ]),
            ]),
          ]),
        ],
        selectedRoute: WebMainScreen.id);
  }
}
