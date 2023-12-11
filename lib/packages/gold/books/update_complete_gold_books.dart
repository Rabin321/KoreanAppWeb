// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import 'package:korean_app_web/packages/gold/books/gold_books_model.dart';
import 'package:korean_app_web/packages/gold/movies/gold_movies_model.dart';

import '../../../customs/widgets/ecobutton.dart';
import '../../../customs/widgets/ecotextfield.dart';

class UpdateCompleteGoldBooks extends StatefulWidget {
  String? id;
  GoldBooksModel? goldbooksModel;
  UpdateCompleteGoldBooks({
    Key? key,
    this.id,
    this.goldbooksModel,
  }) : super(key: key);

  @override
  State<UpdateCompleteGoldBooks> createState() =>
      _UpdateCompleteGoldBooksState();
}

class _UpdateCompleteGoldBooksState extends State<UpdateCompleteGoldBooks> {
  TextEditingController titleGoldBook = TextEditingController();

  TextEditingController urlGoldBook = TextEditingController();

  // String? selectedValue;
  bool isSaving = false;
  bool isUploading = false;

  XFile? pickedDocument;
  String documentUrls = "";

  var uuid = const Uuid();

  @override
  void initState() {
    titleGoldBook.text = widget.goldbooksModel!.title;
    urlGoldBook.text = widget.goldbooksModel!.booksUrl!;
    pickedDocument = XFile(widget.goldbooksModel!.bookFile!);

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
                  padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                  child: Column(
                    children: [
                      const Text(
                        "UPDATE GOLD BOOK",
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
                        labelText: "Book Title",
                        controller: titleGoldBook,
                        hintText: "enter gold book title...",
                        validate: (v) {
                          if (v!.isEmpty) {
                            return "should not be empty";
                          }
                          return null;
                        },
                      ),
                      EcoTextField(
                        labelText: "Video URL",
                        controller: urlGoldBook,
                        hintText: "enter gold book url...",
                        validate: (v) {
                          if (v!.isEmpty) {
                            return "should not be empty";
                          }
                          return null;
                        },
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                EcoButton(
                                  title: "PICK BOOK",
                                  onPress: () {
                                    pickDocument();
                                  },
                                  isLoginButton: true,
                                ),
                                // EcoButton(
                                //   title: "SAVE",
                                //   isLoginButton: true,
                                //   onPress: () {
                                //     save();
                                //   },
                                //   isLoading: isSaving,
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 1.9.h, right: 1.w), // yo uta miauna parxa
                            child: Column(
                              children: [
                                Container(
                                  height: 10.h,
                                  width: 40.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  // child: pickedAudio != null
                                  child: pickedDocument != null
                                      ? Stack(
                                          children: [
                                            SizedBox(
                                              height: 10.h,
                                              width: 40.h,
                                              child: Icon(
                                                Icons.picture_as_pdf,
                                                // size: 15.w,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (pickedDocument !=
                                                        null) {
                                                      // pickedImage.removeAt(index);
                                                      pickedDocument = null;
                                                    }
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.cancel_outlined)),
                                          ],
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ],
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
    if (titleGoldBook.text.isEmpty) {
      setState(() {
        isSaving = false;
        // });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("PLEASE FILL BOOK TITLE"),
          backgroundColor: Colors.red[600],
        ));
      });
    } else if (urlGoldBook.text.isEmpty && pickedDocument == null) {
      setState(() {
        isSaving = false;
        // });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("PLEASE FILL BOOK URL OR FILE"),
          backgroundColor: Colors.red[600],
        ));
      });
    } else if (urlGoldBook.text.isNotEmpty && pickedDocument != null) {
      setState(() {
        isSaving = false;
        // });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
              "BOOK URL AND FILE SHOULD NOT BE FILLED AT THE SAME TIME"),
          backgroundColor: Colors.red[600],
        ));
      });
    } else if (titleGoldBook.text.isNotEmpty && urlGoldBook.text.isNotEmpty ||
        pickedDocument != null) {
      await uploadDocument();
      await GoldBooksModel.updateGoldBooks(
              widget.id!,
              GoldBooksModel(
                  id: uuid.v4(),
                  title: titleGoldBook.text,
                  booksUrl: urlGoldBook.text,
                  bookFile: documentUrls))
          .whenComplete(() {
        setState(() {
          isSaving = false;
          pickedDocument;

          clearFields();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("UPDATED SUCCESSFULLY"),
            backgroundColor: Colors.green[800],
          ));
        });
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      });
    }
  }

  clearFields() {
    setState(() {
      // selectedValue = "";
      titleGoldBook.clear();
      urlGoldBook.clear();
      pickedDocument = null;
    });
  }

  pickDocument() async {
    FilePickerResult? pickDocument = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc']);
    if (pickDocument != null) {
      setState(() {
        print("Doc picked");
        // pickedAudio = XFile(pickAudio.files.single.path!);
        // Uint8List? pickedAudio = pickAudio.files.single.bytes;
        // pickedAudio = XFile.fromData(, name: pickAudio.files.single.name);
        pickedDocument = XFile.fromData(
          pickDocument.files.single.bytes!,
          name: pickDocument.files.single.name,
        );
      });
    } else {
      print("Not selected");
    }
  }

  Future<String?> postDocument(XFile? documentFile) async {
    setState(() {
      isUploading = true;
    });
    String? urls;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("gold_books")
        .child(documentFile!.name);
    if (kIsWeb) {
      await ref.putData(
        await documentFile.readAsBytes(),
        SettableMetadata(contentType: "text/pdf,docx"),
      );
      urls = await ref.getDownloadURL();
      setState(() {
        isUploading = false;
        documentUrls = urls!;
      });
      return urls;
    }
    return null;
  }

  Future<void> uploadDocument() async {
    if (pickedDocument != null) {
      try {
        await postDocument(pickedDocument).then((downloadUrl) => documentUrls);
      } catch (e) {
        print('Error uploading audio: $e');
      }

      // }
    }
  }
}
