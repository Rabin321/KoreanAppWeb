import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:korean_app_web/presentation/practice/listening/listening_model.dart';
import 'package:uuid/uuid.dart';

import '../../../customs/widgets/ecobutton.dart';
import '../../../customs/widgets/ecotextfield.dart';

class AddQuiz extends StatefulWidget {
  static const String id = "addquiz";

  const AddQuiz({super.key});

  @override
  State<AddQuiz> createState() => _AddQuizState();
}

class _AddQuizState extends State<AddQuiz> {
  TextEditingController correctAnswer = TextEditingController();
  bool isSaving = false;
  var uuid = const Uuid();
  bool isUploading = false;
  final imagePicker = ImagePicker();
  XFile? pickedQuestionImage;
  String questionImageUrl = "";

  List<String> options = ["", "", "", ""];
  List<String> optionImages = ["", "", "", ""];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                const Text(
                  "ADD QUIZ",
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    pickQuestionImage();
                  },
                  child: Text("Pick Question Image"),
                ),
                Container(
                  height: 0.18 * MediaQuery.of(context).size.height,
                  width: 0.18 * MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: pickedQuestionImage != null
                      ? Stack(
                          children: [
                            SizedBox(
                                // height: 20.h,
                                // width: 20.h,
                                child: Image.network(
                              File(pickedQuestionImage!.path).path,
                              fit: BoxFit.fill,
                            )),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (pickedQuestionImage != null) {
                                      // pickedImage.removeAt(index);
                                      pickedQuestionImage = null;
                                    }
                                  });
                                },
                                icon: const Icon(Icons.cancel_outlined)),
                          ],
                        )
                      : const SizedBox(),
                ),
                Text("Enter Options:"),
                for (int i = 0; i < 4; i++)
                  EcoTextField(
                    labelText: "Option ${i + 1}",
                    controller: TextEditingController(text: options[i]),
                    hintText: "Enter option...",
                    validate: (v) {
                      if (v!.isEmpty) {
                        return "Should not be empty";
                      }
                      return null;
                    },
                  ),
                EcoTextField(
                  labelText: "Correct Image Position",
                  controller: correctAnswer,
                  hintText: "Enter correct image position (1-4)",
                  validate: (v) {
                    if (v!.isEmpty ||
                        int.tryParse(v) == null ||
                        int.parse(v) < 1 ||
                        int.parse(v) > 4) {
                      return "Enter a valid position (1-4)";
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

    if (pickedQuestionImage == null) {
      setState(() {
        isSaving = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please pick a question image"),
          backgroundColor: Colors.red[600],
        ));
      });
    } else if (options.any((option) => option.isEmpty)) {
      setState(() {
        isSaving = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please fill all option fields"),
          backgroundColor: Colors.red[600],
        ));
      });
    } else if (correctAnswer.text.isEmpty) {
      setState(() {
        isSaving = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please enter the correct image position"),
          backgroundColor: Colors.red[600],
        ));
      });
    } else {
      await uploadQuestionImage();
      await PracticeListeningModel.addPracticeListening(
        PracticeListeningModel(
          id: uuid.v4(),
          questionimage: questionImageUrl,
          options: options,
          correctAnswer: correctAnswer.text,
        ),
      ).whenComplete(() {
        setState(() {
          isSaving = false;
          clearFields();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("ADDED SUCCESSFULLY"),
            backgroundColor: Colors.green[800],
          ));
        });
      });
    }
  }

  clearFields() {
    setState(() {
      pickedQuestionImage = null;
      questionImageUrl = "";
      for (int i = 0; i < 4; i++) {
        options[i] = "";
        optionImages[i] = "";
      }
      correctAnswer.clear();
    });
  }

  pickQuestionImage() async {
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        pickedQuestionImage = pickedImage;
      });
    } else {
      print("No image selected");
    }
  }

  Future postQuestionImage(XFile? imageFile) async {
    setState(() {
      isUploading = true;
    });
    String? url;

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("practiceListeningImages")
        .child(imageFile!.name);
    if (kIsWeb) {
      await ref.putData(
        await imageFile.readAsBytes(),
        SettableMetadata(contentType: "image/jpeg"),
      );
      url = await ref.getDownloadURL();

      setState(() {
        isUploading = false;
        questionImageUrl = url!;
      });
      return url;
    }
  }

  Future<void> uploadQuestionImage() async {
    if (pickedQuestionImage != null) {
      try {
        await postQuestionImage(pickedQuestionImage)
            .then((downloadUrl) => questionImageUrl);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }
}
