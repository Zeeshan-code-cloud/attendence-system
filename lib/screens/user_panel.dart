import 'package:ezitech_internship2/screens/user_login.dart';
import 'package:ezitech_internship2/screens/user_registration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserPanel extends StatelessWidget {
  const UserPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Panel", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold,color: Colors.black54),),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 200,),
              ElevatedButton(onPressed: (){
                print('working');
                Get.to(() =>  const LoginUser());
              }, child: const Text("Login User",style: TextStyle(
                  fontSize: 25.0
              ),)),
              const SizedBox(height: 20,),

              ElevatedButton(onPressed: (){
                Get.to(() => const UserRegistration());
              }, child: const Text("Register User", style: TextStyle(
                  fontSize: 25.0
              ),))
            ],
          ),
        ),
      ),
    );
  }
}
