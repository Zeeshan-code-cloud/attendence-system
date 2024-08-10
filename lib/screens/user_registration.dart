import 'dart:io';
import 'package:ezitech_internship2/screens/upload_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ezitech_internship2/screens/user_login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final name_controller = TextEditingController();
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Registration",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0,
              color: Colors.black54),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: name_controller,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: "Name...",
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: email_controller,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: "Email...",
                  filled: true,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: password_controller,
                obscureText: true,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password...",
                    filled: true,
                    suffixIcon: Icon(Icons.visibility)),
              ),
              const SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                  onPressed: () async {
                    ProgressDialog progressdialog = ProgressDialog(context,
                        title: const Text("Processing "),
                        message: const Text("Please wait"));
                    progressdialog.show();
                    try {
                      FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: email_controller.text.toString(),
                              password: password_controller.text.toString())
                          .then((value) {
                        FirebaseFirestore.instance.collection("Users")
                            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                            .set({
                          "name" : name_controller.text.toString(),
                          "email" : email_controller.text.toString(),
                          "password" : password_controller.text.toString(),
                          "userImage" : "",
                        });
                        progressdialog.dismiss();
                        Get.to(() => const UploadImage(), transition: Transition.leftToRight);
                      });
                    } on FirebaseAuthException catch (e) {
                      progressdialog.dismiss();

                      if (e.code == "email-already-in-use") {
                        Get.snackbar("Alert", "try another email");
                      } else if (e.code == "weak-password") {
                        Get.snackbar("Alert", "Please provide strong password");
                      } else {
                        progressdialog.dismiss();
                        Get.snackbar("Alert",
                            "the following error are occurred\n${e.toString()}");
                      }
                    }
                  },
                  child: const Text(
                    "Registered",
                    style: TextStyle(fontSize: 25.0),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
