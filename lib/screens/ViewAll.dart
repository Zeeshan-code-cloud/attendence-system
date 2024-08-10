import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezitech_internship2/screens/UserMainPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Viewall extends StatefulWidget {
  const Viewall({super.key});

  @override
  State<Viewall> createState() => _ViewallState();
}

class _ViewallState extends State<Viewall> {
  final storage_ref = FirebaseFirestore.instance.collection("studentList").snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student List",
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Colors.indigo
        ),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: StreamBuilder(
            stream: storage_ref,
            builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index){
              return   ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(snapshot.data!.docs[index]["user_img"]),
                ),
                title: Text(snapshot.data!.docs[index]["email"], style: const TextStyle(
                  fontSize: 22.0, fontWeight: FontWeight.w700, color: Colors.green
                ),),
                subtitle: Text(snapshot.data!.docs[index]["Ispresent"],style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.indigo
                ),),
                trailing: Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                       decoration: BoxDecoration(
                         color: snapshot.data!.docs[index]["Ispresent"] == "Present" ? Colors.green : Colors.red,
                         borderRadius: BorderRadius.circular(22.0)
                       ),
                    ),
                    const SizedBox(height: 5.0,),
                    InkWell(
                      onTap: (){
                        Get.to(() => const Usermainpage());
                      },
                      child: const Text("Edite", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                    )
                  ],
                )
              );
            });
          },))
        ],
      ) ,
    );
  }
}
