// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:korean_app_web/presentation/practice/listening/listening_model.dart';
import 'package:korean_app_web/presentation/practice/reading/reading_model.dart';
import 'package:korean_app_web/utils/app_colors.dart';

import '../../../customs/widgets/ecobutton.dart';
import '../../../customs/widgets/ecotextfield.dart';

class UpdateCompleteReading extends StatefulWidget {
  String? id;
  PracticeReadingModel? practiceReadingModel;
  UpdateCompleteReading({
    Key? key,
    this.id,
    this.practiceReadingModel,
  }) : super(key: key);

  @override
  State<UpdateCompleteReading> createState() => _UpdateCompleteReadingState();
}

class _UpdateCompleteReadingState extends State<UpdateCompleteReading> {
  TextEditingController correctAnswer = TextEditingController();
  TextEditingController title = TextEditingController();
  bool isSaving = false;
  var uuid = const Uuid();
  bool isUploading = false;
  final imagePicker = ImagePicker();
  XFile? pickedImage;
  String imageUrls = "";

  List<String> options = ["", "", "", ""];

  @override
  void initState() {
    title.text = widget.practiceReadingModel!.title;
    correctAnswer.text = widget.practiceReadingModel!.correctAnswer;
    pickedImage = XFile(widget.practiceReadingModel!.imageUrl);
    for (int i = 0; i < 4; i++) {
      options[i] = widget.practiceReadingModel!.options[i];
    }

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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    const Text(
                      "UPDATE READING IMAGE",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    child: Text("Pick Image"),
                                    onPressed: () => pickImage(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                    )),
                                Container(
                                    height: 100.h,
                                    width: 40.w,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: pickedImage != null
                                        ? Stack(
                                            children: [
                                              SizedBox(
                                                  height: 100.h,
                                                  width: 40.w,
                                                  child: Image.network(
                                                    File(pickedImage!.path)
                                                        .path,
                                                    fit: BoxFit.fill,
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (pickedImage != null) {
                                                        // pickedImage.removeAt(index);
                                                        pickedImage = null;
                                                      }
                                                    });
                                                  },
                                                  icon: const Icon(
                                                      Icons.cancel_outlined))
                                            ],
                                          )
                                        : SizedBox()),
                              ],
                            ),
                          ]),
                    ),
                    EcoTextField(
                      labelText: "Title",
                      controller: title,
                      hintText: "enter audio title...",
                      validate: (v) {
                        if (v!.isEmpty) {
                          return "should not be empty";
                        }
                        return null;
                      },
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Enter Options:",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                    for (int i = 0; i < 4; i++)
                      EcoTextField(
                        labelText: "Option ${i + 1}",
                        controller: TextEditingController(text: options[i]),
                        hintText: "Enter option...",
                        onChanged: (value) {
                          options[i] =
                              value; // Update the options list when the text changes
                        },
                        validate: (v) {
                          if (v!.isEmpty) {
                            return "Should not be empty";
                          }
                          return null;
                        },
                      ),
                    EcoTextField(
                      labelText: "Correct Position",
                      controller: correctAnswer,
                      hintText: "Enter correct position (1-4)",
                      onChanged: (value) {
                        // Ensure that the input is an integer between 1 and 4
                        if (value.isNotEmpty) {
                          int parsedValue = int.tryParse(value) ?? 0;
                          if (parsedValue < 1 || parsedValue > 4) {
                            correctAnswer.text =
                                ""; // Clear the input if it doesn't meet the criteria
                          }
                        }
                      },
                      validate: (v) {
                        if (v!.isEmpty) {
                          return "Should not be empty";
                        }
                        if (int.tryParse(v) == null ||
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
        ),
      ),
    );
  }

  void save() async {
    setState(() {
      isSaving = true;
    });

    if (pickedImage == null) {
      setState(() {
        isSaving = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please pick a audio file"),
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
          content: Text("Please enter the correct position"),
          backgroundColor: Colors.red[600],
        ));
      });
    } else {
      int parsedValue = int.tryParse(correctAnswer.text) ?? 0;
      if (parsedValue < 1 || parsedValue > 4) {
        setState(() {
          isSaving = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Please enter a valid position (1-4)"),
            backgroundColor: Colors.red[600],
          ));
        });
      } else {
        for (int i = 0; i < 4; i++) {
          options[i] = TextEditingController(text: options[i]).text;
        }

        await uploadImages();
        await PracticeReadingModel.updatePracticeReading(
          widget.id!,
          PracticeReadingModel(
            id: uuid.v4(),
            title: title.text,
            imageUrl: imageUrls,
            options: options,
            correctAnswer: correctAnswer.text,
          ),
        ).whenComplete(() {
          setState(() {
            isSaving = false;
            pickedImage;
            clearFields();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("UPDATED SUCCESSFULLY"),
              backgroundColor: Colors.green[800],
            ));
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context);
            });
          });
        });
      }
    }
  }

  clearFields() {
    setState(() {
      pickedImage = null;
      title.clear();

      for (int i = 0; i < 4; i++) {
        options[i] = "";
      }
      correctAnswer.clear();
    });
  }

  pickImage() async {
    final XFile? pickImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickImage != null) {
      setState(() {
        // pickedImage.addAll(pickImage);
        pickedImage = pickImage;
      });
    } else {
      print("no images selected");
    }
  }

  Future postImages(XFile? imageFile) async {
    setState(() {
      isUploading = true;
    });
    String? urls;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("practice_reading_Images")
        .child(imageFile!.name);
    if (kIsWeb) {
      await ref.putData(
        await imageFile.readAsBytes(),
        SettableMetadata(contentType: "image/jpeg"),
      );
      urls = await ref.getDownloadURL();
      setState(() {
        isUploading = false;
        imageUrls = urls!;
      });
      return urls;
    }
  }

  Future<void> uploadImages() async {
    if (pickedImage != null) {
      try {
        await postImages(pickedImage).then((downloadUrl) => imageUrls);
        // pickedImage.add(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }
}
