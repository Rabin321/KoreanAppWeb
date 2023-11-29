import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import '../../../customs/widgets/ecobutton.dart';
import '../../../customs/widgets/ecotextfield.dart';
import 'grammar_model.dart';

class AddGrammar extends StatefulWidget {
  // const AddLifeSkills({Key? key}) : super(key: key);
  static const String id = "addgrammar";

  const AddGrammar({super.key});

  @override
  State<AddGrammar> createState() => _AddGrammarState();
}

class _AddGrammarState extends State<AddGrammar> {
  TextEditingController word = TextEditingController();
  TextEditingController kDetail = TextEditingController();
  TextEditingController kExample = TextEditingController();
  TextEditingController nDetail = TextEditingController();
  TextEditingController nExample = TextEditingController();
  TextEditingController eDetail = TextEditingController();
  TextEditingController eExample = TextEditingController();
  // String? selectedValue;
  bool isSaving = false;
  bool isUploading = false;

  var uuid = const Uuid();
  @override
  Widget build(BuildContext context) {
    return Material(
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
                      "ADD GRAMMAR",
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
                      labelText: "Word",
                      maxLines: 1,
                      controller: word,
                      hintText: "enter word",
                      validate: (v) {
                        if (v!.isEmpty) {
                          return "should not be empty";
                        }
                        return null;
                      },
                    ),
                    EcoTextField(
                      labelText: "Korean Detail",
                      maxLines: 2,
                      controller: kDetail,
                      hintText: "enter detail in korean",
                      validate: (v) {
                        if (v!.isEmpty) {
                          return "should not be empty";
                        }
                        return null;
                      },
                    ),
                    EcoTextField(
                      labelText: "Korean Example",
                      maxLines: 2,
                      controller: kExample,
                      hintText: "enter example in korean",
                      validate: (v) {
                        if (v!.isEmpty) {
                          return "should not be empty";
                        }
                        return null;
                      },
                    ),
                    EcoTextField(
                      labelText: "Nepali Detail",
                      maxLines: 2,
                      controller: nDetail,
                      hintText: "enter detail in nepali",
                      validate: (v) {
                        if (v!.isEmpty) {
                          return "should not be empty";
                        }
                        return null;
                      },
                    ),
                    EcoTextField(
                      labelText: "Nepali Example",
                      maxLines: 2,
                      controller: nExample,
                      hintText: "enter example in nepali",
                      validate: (v) {
                        if (v!.isEmpty) {
                          return "should not be empty";
                        }
                        return null;
                      },
                    ),
                    EcoTextField(
                      labelText: "English Detail",
                      maxLines: 2,
                      controller: eDetail,
                      hintText: "enter detail in english",
                      validate: (v) {
                        if (v!.isEmpty) {
                          return "should not be empty";
                        }
                        return null;
                      },
                    ),
                    EcoTextField(
                      labelText: "English Example",
                      maxLines: 2,
                      controller: eExample,
                      hintText: "enter example in english",
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
    );
  }

  save() async {
    setState(() {
      isSaving = true;
    });

    if (word.text.isEmpty ||
        kDetail.text.isEmpty ||
        nDetail.text.isEmpty ||
        eDetail.text.isEmpty ||
        kExample.text.isEmpty ||
        nExample.text.isEmpty ||
        eExample.text.isEmpty) {
      setState(() {
        isSaving = false;
        // });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("PLEASE FILL ALL THE FIELDS"),
          backgroundColor: Colors.red[600],
        ));
      });
    } // Query to check if any "About Us" data already exists in Firestore
    final querySnapshot =
        await FirebaseFirestore.instance.collection('grammarWord').get();

    // if (querySnapshot.docs.isNotEmpty) {
    //   // Data already exists, display a snackbar and exit
    //   setState(() {
    //     isSaving = false;

    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: const Text(
    //           " already exists!\nCannot add more than one term of service"),
    //       backgroundColor: Colors.red[600],
    //     ));
    //   });
    // }

    if (word.text.isNotEmpty &&
        kDetail.text.isNotEmpty &&
        nDetail.text.isNotEmpty &&
        eDetail.text.isNotEmpty &&
        kExample.text.isNotEmpty &&
        nExample.text.isNotEmpty &&
        eExample.text.isNotEmpty) {
      // await uploadImages();
      await GrammarWordModel.addGrammarWord(GrammarWordModel(
        id: uuid.v4(),
        word: word.text,
        kDetail: kDetail.text,
        kExample: kExample.text,
        nDetail: nDetail.text,
        nExample: nExample.text,
        eDetail: eDetail.text,
        eExample: eExample.text,
      )).whenComplete(() {
        setState(() {
          isSaving = false;

          // images.clear();
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
      word.clear();
      kDetail.clear();
      nDetail.clear();
      eDetail.clear();
    });
  }
}
