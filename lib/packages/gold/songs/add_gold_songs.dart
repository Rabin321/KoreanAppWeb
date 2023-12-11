import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:korean_app_web/packages/gold/songs/gold_songs_model.dart';

import 'package:sizer/sizer.dart';

import 'package:uuid/uuid.dart';

import '../../../customs/widgets/ecobutton.dart';
import '../../../customs/widgets/ecotextfield.dart';
import '../../../utils/app_colors.dart';

class AddGoldSongs extends StatefulWidget {
  static const String id = "addgoldsongs";

  const AddGoldSongs({super.key});

  @override
  State<AddGoldSongs> createState() => _AddGoldSongsState();
}

class _AddGoldSongsState extends State<AddGoldSongs> {
  TextEditingController titleGoldSong = TextEditingController();

  // TextEditingController urlVocAud = TextEditingController();

  // String? selectedValue;
  bool isSaving = false;
  bool isUploading = false;

  final imagePicker = ImagePicker();
  XFile? pickedImage;
  String imageUrls = "";

  XFile? pickedAudio;
  String AudioUrls = "";

  var uuid = const Uuid();
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
                  "ADD GOLD SONG",
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                  child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                child: Text("Pick Song"),
                                onPressed: () => pickAudio(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                )),
                            Container(
                                height: 4.h,
                                width: 12.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: pickedAudio != null
                                    ? Stack(
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 35),
                                            // alignment: Alignment.center,
                                              height: 10.h,
                                            // width: 10.h,
                                            child: const Icon(Icons.music_note),
                                          ),
                                          const Center(
                                              child: Text(
                                            "Song added",
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
                  controller: titleGoldSong,
                  hintText: "enter song title...",
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

    if (titleGoldSong.text.isEmpty || pickedAudio == null
        // pickedImage == null
        ) {
      setState(() {
        isSaving = false;
        // });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("PLEASE FILL ALL THE FIELDS"),
          backgroundColor: Colors.red[600],
        ));
      });
    } else if (titleGoldSong.text.isNotEmpty && pickedAudio != null
        // pickedImage != null

        ) {
      await uploadAudios();
      // await uploadImages();

      await GoldSongsModel.addAudio(GoldSongsModel(
        id: uuid.v4(),
        title: titleGoldSong.text,
        audioUrl: AudioUrls,
        // imageUrls: imageUrls,
      )).whenComplete(() {
        setState(() {
          isSaving = false;
          pickedAudio;
          // pickedImage;

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
      titleGoldSong.clear();
      // pickedImage = null;
      pickedAudio = null;
      // imageUrls = '';
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

  Future<String?> postAudios(XFile? audioFile) async {
    setState(() {
      isUploading = true;
    });
    String? urls;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("gold_songs")
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

  // Future postImages(XFile? imageFile) async {
  //   setState(() {
  //     isUploading = true;
  //   });
  //   String? urls;
  //   Reference ref = FirebaseStorage.instance
  //       .ref()
  //       .child("gold_songs_images")
  //       .child(imageFile!.name);
  //   if (kIsWeb) {
  //     await ref.putData(
  //       await imageFile.readAsBytes(),
  //       SettableMetadata(contentType: "image/jpeg"),
  //     );
  //     urls = await ref.getDownloadURL();
  //     setState(() {
  //       isUploading = false;
  //       imageUrls = urls!;
  //     });
  //     return urls;
  //   }
  // }

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

  // Future<void> uploadImages() async {
  //   if (pickedImage != null) {
  //     try {
  //       await postImages(pickedImage).then((downloadUrl) => imageUrls);
  //       // pickedImage.add(downloadUrl);
  //     } catch (e) {
  //       print('Error uploading image: $e');
  //     }
  //   }
  // }
}
