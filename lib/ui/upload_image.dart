import 'dart:io';

import 'package:doctor_app/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../util/utils.dart';

class ImageUploadSecreen extends StatefulWidget {
  const ImageUploadSecreen({super.key});

  @override
  State<ImageUploadSecreen> createState() => _ImageUploadSecreenState();
}

class _ImageUploadSecreenState extends State<ImageUploadSecreen> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  Future getGalaryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("no image picked");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('upload image'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getGalaryImage();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : Center(child: Icon(Icons.image)),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                title: "Upload",
                loading: loading,
                onTap: () {
                  uploadImage();
                })
          ],
        ),
      ),
    );
  }

  void uploadImage() {
    setState(() {
      loading = true;
    });
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('/asiftaj/' + DateTime.now().millisecondsSinceEpoch.toString());
    firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

    Future.value(uploadTask).then((value) async {
      var newUrl = await ref.getDownloadURL();
      databaseRef
          .child('1')
          .set({'id': '1212', 'title': newUrl.toString()}).then((value) {
        setState(() {
          loading = false;
        });
        Utils().toastMessageSuccess('uploaded');
      }).onError((error, stackTrace) {
        print(error.toString());
        setState(() {
          loading = false;
        });
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }
}
