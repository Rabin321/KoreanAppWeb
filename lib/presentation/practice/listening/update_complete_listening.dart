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

import '../../../customs/widgets/ecobutton.dart';
import '../../../customs/widgets/ecotextfield.dart';
import '../../../utils/app_colors.dart';

class UpdateCompleteListening extends StatefulWidget {
  String? id;
  PracticeListeningModel? practiceListeningModel;
  UpdateCompleteListening({
    Key? key,
    this.id,
    this.practiceListeningModel,
  }) : super(key: key);

  @override
  State<UpdateCompleteListening> createState() =>
      _UpdateCompleteListeningState();
}

class _UpdateCompleteListeningState extends State<UpdateCompleteListening> {
  TextEditingController correctAnswer = TextEditingController();
  TextEditingController title = TextEditingController();
  bool isSaving = false;
  var uuid = const Uuid();
  bool isUploading = false;
  final imagePicker = ImagePicker();
  XFile? pickedAudio;
  String AudioUrls = "";

  List<String> options = ["", "", "", ""];

  @override
  void initState() {
    title.text = widget.practiceListeningModel!.title;
    correctAnswer.text = widget.practiceListeningModel!.correctAnswer;
    pickedAudio = XFile(widget.practiceListeningModel!.audioUrl);
    for (int i = 0; i < 4; i++) {
      options[i] = widget.practiceListeningModel!.options[i];
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
                      "UPDATE LISTINING AUDIO",
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
                                    child: Text("Pick Audio"),
                                    onPressed: () => pickAudio(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                    )),
                                Container(
                                    height: 30.h,
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: pickedAudio != null
                                        ? Stack(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 35),
                                                // alignment: Alignment.center,
                                                height: 10.h,
                                                // width: 10.h,
                                                // child: const Icon(
                                                //     Icons.music_note

                                                // ),
                                              ),
                                              const Center(
                                                  child: Text(
                                                "Audio added",
                                                style: TextStyle(fontSize: 18),
                                              )),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (pickedAudio != null) {
                                                        // pickedImage.removeAt(index);
                                                        pickedAudio = null;
                                                      }
                                                    });
                                                  },
                                                  icon: const Icon(
                                                      Icons.cancel_outlined)),
                                            ],
                                          )
                                        : const SizedBox()),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
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

    if (pickedAudio == null) {
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

        await uploadAudios();
        await PracticeListeningModel.updatePracticeListening(
          widget.id!,
          PracticeListeningModel(
            id: uuid.v4(),
            title: title.text,
            audioUrl: AudioUrls,
            options: options,
            correctAnswer: correctAnswer.text,
          ),
        ).whenComplete(() {
          setState(() {
            isSaving = false;
            pickedAudio;
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
      pickedAudio = null;
      title.clear();

      for (int i = 0; i < 4; i++) {
        options[i] = "";
      }
      correctAnswer.clear();
    });
  }

  pickAudio() async {
    FilePickerResult? pickAudio =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (pickAudio != null) {
      setState(() {
        print("Audio picked");
        // pickedAudio = XFile(pickAudio.files.single.path!);
        // Uint8List? pickedAudio = pickAudio.files.single.bytes;
        // pickedAudio = XFile.fromData(, name: pickAudio.files.single.name);
        pickedAudio = XFile.fromData(
          pickAudio.files.single.bytes!,
          name: pickAudio.files.single.name,
        );

        print("Audio picked2");
      });
    } else {
      print("No audio selected");
    }
  }

  Future<String?> postAudios(XFile? audioFile) async {
    setState(() {
      isUploading = true;
    });
    String? urls;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("practice_listening")
        .child(audioFile!.name);
    if (kIsWeb) {
      await ref.putData(
        await audioFile.readAsBytes(),
        SettableMetadata(contentType: "audio/mp3"),
      );
      urls = await ref.getDownloadURL();
      setState(() {
        isUploading = false;
        AudioUrls = urls!;
      });
      return urls;
    }
    return null;
  }

  Future<void> uploadAudios() async {
    if (pickedAudio != null) {
      try {
        await postAudios(pickedAudio).then((downloadUrl) => AudioUrls);
      } catch (e) {
        print('Error uploading audio: $e');
      }

      // }
    }
  }
}
