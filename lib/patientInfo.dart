import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sencare/editpatient.dart';
import 'package:sencare/testsListScreen.dart';
import 'package:http/http.dart' as http;

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

class _PatientInfoState extends State<PatientInfo>{
  // final String receiveID;
  // constructor
  // const PatientInfo(this.receiveID, {super.key});
  bool _isLoading = true;
  String _errorMessage = '';
  Map<String, dynamic> patientData = {};
  
  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
  }
  void fetchPatientDetails() async {
    try {
      final url = 'http://172.16.7.126:3000/api/patients/${widget.patientId}';
      final response = await http.get(Uri.parse(url));

      if(response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          patientData = json;
          _isLoading = false;
        });
      }
      else {
        throw Exception('Failed on load patient details');
      }
    }catch (error){
      setState(() {
        _errorMessage = 'failed to load patient details: ${error.toString()}';
        _isLoading = false;
      });
      

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Info'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.person_2_outlined, size: 120),
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
                          fetchPatientDetails();
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
                  child: Text(
                    'Sample data',
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
                    'Sample data',
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
                    'Sample data',
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
                    'Sample data',
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
                    'Sample data',
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
                    'Sample data',
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
        ),
      ),
    );
  }
}
