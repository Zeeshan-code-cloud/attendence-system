import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezitech_internship2/screens/user_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  File? image;
  final imagepicker = ImagePicker();

  Future<void> GetImageGallery() async {
    XFile? pickedfile = await imagepicker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if(pickedfile != null) {
      setState(() {
        image = File(pickedfile.path);
      });
    }
    //now to upload image to firebase storage
    await  UploadImage_Storage();
  }

  Future<void> UploadImage_Storage() async {
    if(image == null) return;
    String Unique_file = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storage_ref = FirebaseStorage.instance.ref().child("Image/$Unique_file");
    UploadTask uploadTask = storage_ref.putFile(image!);

    TaskSnapshot snapshot = await uploadTask.whenComplete((){});
    String ImageUrl = await  snapshot.ref.getDownloadURL();
print(ImageUrl.toString());
    //now to update the corresponding field in firebase firestore

    final coll_ref =  FirebaseFirestore.instance.collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid.toString()).update({
      "userImage" : ImageUrl.toString(),
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Image", style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Colors.black54
        ),),
          centerTitle: true,
      ),
      body: Center(
        child:
          Stack(children: [
             CircleAvatar(radius: 70,
              child: image != null ? Image.file(image!, fit: BoxFit.cover,) :
           const    Icon(Icons.person_outline_sharp, size: 60,),
            ),
            Positioned(
              top: 90,
              right: 90,
              child: IconButton(
                  onPressed: () async  {
                  await   GetImageGallery();
                  Get.to(() => const  LoginUser() , transition: Transition.rightToLeft);
                  },
                  icon: const Icon(
                    Icons.add_a_photo_rounded,
                    size: 30,
                  )),
            )
          ]),
      ),
    );
  }
}
