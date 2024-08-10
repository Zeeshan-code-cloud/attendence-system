import 'package:ezitech_internship2/screens/UserMainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login", style: TextStyle(
          fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black54
        ),),
            centerTitle: true,
      ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const  SizedBox(height: 40,),
                 const  Text("Welcome Sir!", style: TextStyle(
                    fontSize: 44.0, color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),),
               const    SizedBox(height: 40,),

                  TextField(
                    controller: email_controller,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "Email...",
                      filled: true,

                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  TextField(
                    controller: password_controller,
                    obscureText: true,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Password...",
                        filled: true,
                        suffixIcon: Icon(Icons.visibility)
                    ),
                  ),
                  const SizedBox(height: 40.0,),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {

                          FirebaseAuth auth = FirebaseAuth.instance;
                          ProgressDialog progressDialog = ProgressDialog(context, title: const Text("Processing"),
                              message: const Text("Please wait"));
                          progressDialog.show();

                         try{

                          await  auth.signInWithEmailAndPassword(
                               email: email_controller.text.toString(),
                               password: password_controller.text.toString()).then((value) {
                                 progressDialog.dismiss();
                                 Get.to(() =>  const Usermainpage(), transition: Transition.leftToRight);
                           });
                         }on FirebaseAuthException catch (e) {
                           if(e.code == "user-not-found"){
                             Get.snackbar("Alert!" , "No user are registered\n with this email address");
                           }
                           else if(e.code == "wrong-password"){
                             Get.snackbar("Alert!", "Incorrect password");
                           }
                           else{
                             Get.snackbar("Alert1", "the following error are occurred \n${e.toString()}");
                           }
                         }
                        }, child: const Text("Login", style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold,
                    ),)),
                  )

                ],
              ),
            ),
          ),
    );
  }
}
