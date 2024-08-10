import 'package:ezitech_internship2/screens/ViewAll.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

class Usermainpage extends StatefulWidget {
  const Usermainpage({super.key});

  @override
  State<Usermainpage> createState() => _UsermainpageState();
}

class _UsermainpageState extends State<Usermainpage> {
  final storage_ref  = FirebaseFirestore.instance.collection("Users").
  doc(FirebaseAuth.instance.currentUser!.uid);

  bool ispresent = false ;
  bool isabsent = false ;
  bool leave_req = false;
  final request_controller =  TextEditingController();
  final email_controller =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Expanded(
        child: StreamBuilder(
          stream: storage_ref.snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return  const Center(
                child: CircularProgressIndicator( strokeWidth: 4,color: Colors.indigo,),
              );
            }
            else if(snapshot.hasError){
              return const Center(
                child: Text("Something went wrong", style: TextStyle(
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54
                ),),
              );
            }

            return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage:  NetworkImage(snapshot.data["userImage"]),
                        ),
                      ),
                      Padding(
                        padding: const  EdgeInsets.symmetric(horizontal: 22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const  Text("Welcome!",
                                  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.black54), ),
                                const  SizedBox(width: 12.0,),
                                Text(snapshot.data["name"], style: const  TextStyle(
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo
                                ),
                                ),
                              const   Spacer(),
                                TextButton(onPressed: (){
                                  Get.to(() => const  Viewall());
                                }, child: const Text("View All",style: TextStyle(
                                  fontSize: 22.0,fontWeight: FontWeight.bold,color: Colors.indigo
                                ),))
                              ],
                            ),
                     SizedBox(height: MediaQuery.of(context).size.height*0.2,),
                     Center(
                       child: Column(
                         children: [
                          CheckboxListTile(value: ispresent, onChanged: (value){ispresent = value!;
                           setState(() {
                             isabsent = false;
                           });
                           },
                            title: const Text("Mark Present",
                              style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold,),),),

                           const   SizedBox(height: 20,),
                           CheckboxListTile(value: isabsent, onChanged: (value)
                           {isabsent = value!;
                             setState(() {
                               ispresent = false;
                             });
                           },
                             title: const Text("Mark Absent",
                               style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold,),),),
                           const   SizedBox(height: 20,),
                           ElevatedButton(onPressed: () async{

                             ProgressDialog progressDialog = ProgressDialog(context, title: const Text("Prccessing"), message: const Text("Please wait"));
                             progressDialog.show();
                             await FirebaseFirestore.instance.collection("studentList").
                             doc(FirebaseAuth.instance.currentUser!.uid).set({
                               "email" : snapshot.data["email"],
                               "user_img" : snapshot.data["userImage"],
                               "Ispresent" : ispresent ? "Present" : "absent",
                             }).then((value) {
                               Get.snackbar("Alert1", "operation successful");
                               progressDialog.dismiss();
                             });

                           }, child: const Text("Submit",
                           style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold,color: Colors.green,
                           ),)),
                          const  SizedBox(height: 22.0,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Switch(value: leave_req, onChanged: (val){
                                 leave_req = val;
                                 setState(() {

                                 });
                               }),
                              const  Text("Request for Leave", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.indigo),)
                             ],
                           ),
                           leave_req == true ?
                               Column(
                                 children: [
                                   TextField(
                                     controller: email_controller,
                                   
                                     decoration: const  InputDecoration(
                                       filled: true,
                                       fillColor: Colors.grey,
                                       hintText: "Enter email",
                                       prefixIcon: Icon(Icons.email)
                                     ),
                                   ),
                                  const  SizedBox(height: 10.0,),
                                   TextField(
                                     controller: request_controller,

                                     decoration: const  InputDecoration(
                                       filled: true,
                                       fillColor: Colors.grey,
                                       hintText: "Request for a leave",
                                       prefixIcon: Icon(Icons.message_outlined)
                                     ),
                                   ),
                                   ElevatedButton(onPressed: () async {
                                     await FirebaseFirestore.instance.collection("leave_request").add({
                                       "email" : email_controller.text.toString(),
                                       "leave_request" : request_controller.text.toString()
                                     });

                                   }, child: const Text("Send", style: TextStyle(
                                     fontSize: 23.0, fontWeight: FontWeight.w600,color: Colors.blueGrey
                                   ),))
                                 ],
                               ) : Container(),
                         ],
                       ),
                     )
                          ],
                        ),
                      ),
                    ],
                  );
                }
                );
          },
        ),
      )
    );
  }
}
