import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:korean_app_web/presentation/practice/listening/listening_model.dart';
import 'package:korean_app_web/presentation/practice/reading/reading_model.dart';
import 'package:korean_app_web/utils/app_colors.dart';
import 'package:uuid/uuid.dart';

import '../../../customs/widgets/ecobutton.dart';
import '../../../customs/widgets/ecotextfield.dart';

class AddReading extends StatefulWidget {
  static const String id = "addreading";

  const AddReading({super.key});

  @override
  State<AddReading> createState() => _AddReadingState();
}

class _AddReadingState extends State<AddReading> {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              const Text(
                "ADD READING IMAGE",
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                              File(pickedImage!.path).path,
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
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
        await PracticeReadingModel.addPracticeReading(
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
              content: Text("ADDED SUCCESSFULLY"),
              backgroundColor: Colors.green[800],
            ));
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
