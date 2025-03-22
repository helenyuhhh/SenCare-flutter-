import 'dart:convert';
import 'package:sencare/networkingManager.dart';
import 'package:flutter/material.dart';
import 'package:sencare/editpatient.dart';
import 'package:sencare/testsListScreen.dart';
import 'package:sencare/patientObject.dart';

// this should be stateless widget since it's just displaying, not changing
// a function to receive the patient id
// this should be a stateful widget
class PatientInfo extends StatefulWidget {
  final String patientId;
  const PatientInfo({Key? key, required this.patientId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PatientInfoState();
  }
}

class _PatientInfoState extends State<PatientInfo> {
  // final String receiveID;
  // constructor
  // const PatientInfo(this.receiveID, {super.key});
  
  var patientObject = PatientObject(Name("", ""), 0, "", "", "", "", "", "");

  final NetworkingManager _networkingManager = NetworkingManager();
  String name = "";
  Future getPatientById(String patientId) async {
    patientObject = await _networkingManager.getPatientById(patientId);
    print('patient img link: ${patientObject.picture}');
    print('patient img link: ${patientObject.age}');
    name = patientObject.name.first + " " + patientObject.name.last;
    return patientObject;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Info'),
        
      ),
      body: FutureBuilder(
          future: getPatientById(widget.patientId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
          children: [
             patientObject.picture.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              patientObject.picture,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print("Image error: $error");
                                return Text("No image");
                              },
                            ),
                          )
                        : Icon(Icons.person),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => EditPatient(patientId: widget.patientId)),
                        ).then((_){
                        });
                  },
                  icon: Icon(
                    Icons.edit_square,
                    size: 35,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Name: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  // read from passed object
                  child:
                      Text(name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Room: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  // read from passed object
                  child: Text(
                    patientObject.room,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Gender: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  // read from passed object
                  child: Text(
                    patientObject.gender,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Age: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  // read from passed object
                  child: Text(
                    patientObject.age.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Weight: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  // read from passed object
                  child: Text(
                    patientObject.weight,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Height: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  // read from passed object
                  child: Text(
                    patientObject.height,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TextListScreen()));
            }, child: const Text('Tests'))
          ],
        );
      
              
        } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error loading patient data",
                    style: TextStyle(fontSize: 18, color: Colors.redAccent),)
                  ],
                ),

              );
            } 
          } ),
    );
  }
}
