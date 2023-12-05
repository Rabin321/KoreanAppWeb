import 'package:flutter/material.dart';
import 'package:korean_app_web/packages/gold/movies/gold_movies_model.dart';

import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import '../../../customs/widgets/ecobutton.dart';
import '../../../customs/widgets/ecotextfield.dart';

class UpdateCompleteGoldMovie extends StatefulWidget {
  static const String idd = "updatecompletegoldmovie";

  String? id;

  GoldMovieModel? goldMovieModel;
  UpdateCompleteGoldMovie({
    Key? key,
    this.id,
    this.goldMovieModel,
  }) : super(key: key);

  @override
  State<UpdateCompleteGoldMovie> createState() =>
      _UpdateCompleteGoldMovieState();
}

class _UpdateCompleteGoldMovieState extends State<UpdateCompleteGoldMovie> {
  TextEditingController titleGoldMovie = TextEditingController();

  TextEditingController urlGoldMovie = TextEditingController();

  // String? selectedValue;
  bool isSaving = false;
  bool isUploading = false;

  var uuid = const Uuid();

  @override
  void initState() {
    titleGoldMovie.text = widget.goldMovieModel!.title;
    urlGoldMovie.text = widget.goldMovieModel!.moviesUrl;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      child: Dialog(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      const Text(
                        "UPDATE GOLD VIDEO",
                        // style: EcoStyle.boldStyle,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 17, vertical: 7),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)),
                      ),
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
      await GoldMovieModel.updateGoldMovie(
          widget.id!,
          GoldMovieModel(
            id: uuid.v4(),
            title: titleGoldMovie.text,
            moviesUrl: urlGoldMovie.text,
          )).whenComplete(() {
        setState(() {
          isSaving = false;

          clearFields();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("UPDATED SUCCESSFULLY"),
            backgroundColor: Colors.green[800],
          ));
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
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
