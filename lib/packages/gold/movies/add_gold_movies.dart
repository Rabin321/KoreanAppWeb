import 'package:flutter/material.dart';
import 'package:korean_app_web/packages/gold/movies/gold_movies_model.dart';

import 'package:sizer/sizer.dart';

import 'package:uuid/uuid.dart';

import '../../../customs/widgets/ecobutton.dart';
import '../../../customs/widgets/ecotextfield.dart';

class AddGoldMovie extends StatefulWidget {
  static const String id = "addgoldvideo";

  const AddGoldMovie({super.key});

  @override
  State<AddGoldMovie> createState() => _AddGoldMovieState();
}

class _AddGoldMovieState extends State<AddGoldMovie> {
  TextEditingController titleGoldMovie = TextEditingController();

  TextEditingController urlGoldMovie = TextEditingController();

  // String? selectedValue;
  bool isSaving = false;
  bool isUploading = false;

  var uuid = const Uuid();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
            child: Column(
              children: [
                const Text(
                  "ADD GOLD VIDEO",
                  // style: EcoStyle.boldStyle,
                ),
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 4.h, vertical: 2.h),
                //   decoration: BoxDecoration(
                //       color: Colors.grey.withOpacity(0.5),
                //       borderRadius: BorderRadius.circular(10)),
                // ),
                EcoTextField(
                  maxLines: 1,
                  labelText: "Video Title",
                  controller: titleGoldMovie,
                  hintText: "enter gold video title...",
                  validate: (v) {
                    if (v!.isEmpty) {
                      return "should not be empty";
                    }
                    return null;
                  },
                ),
                EcoTextField(
                  labelText: "Video URL",
                  controller: urlGoldMovie,
                  hintText: "enter gold video url...",
                  validate: (v) {
                    if (v!.isEmpty) {
                      return "should not be empty";
                    }
                    return null;
                  },
                ),
                EcoButton(
                  title: "SAVE",
                  isLoginButton: true,
                  onPress: () {
                    save();
                  },
                  isLoading: isSaving,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  save() async {
    setState(() {
      isSaving = true;
    });
    if (titleGoldMovie.text.isEmpty || urlGoldMovie.text.isEmpty) {
      setState(() {
        isSaving = false;
        // });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("PLEASE FILL ALL THE FIELDS"),
          backgroundColor: Colors.red[600],
        ));
      });
    } else if (titleGoldMovie.text.isNotEmpty && urlGoldMovie.text.isNotEmpty) {
      await GoldMovieModel.addGoldMovie(GoldMovieModel(
        id: uuid.v4(),
        title: titleGoldMovie.text,
        moviesUrl: urlGoldMovie.text,
      )).whenComplete(() {
        setState(() {
          isSaving = false;

          clearFields();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("ADDED SUCCESSFULLY"),
            backgroundColor: Colors.green[800],
          ));
        });
      });
    }
  }

  clearFields() {
    setState(() {
      // selectedValue = "";
      titleGoldMovie.clear();
      urlGoldMovie.clear();
    });
  }
}
