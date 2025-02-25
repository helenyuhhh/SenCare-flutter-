import 'package:flutter/material.dart';

class PatientListScreen extends StatefulWidget{
  // variable to receive the passed username
  final String receiveUsername;
  // constructor
  const PatientListScreen(this.receiveUsername);
  
  @override
  State<StatefulWidget> createState() {
    return _PatientListState();
  }
}

class _PatientListState extends State<PatientListScreen> {
  // variable to receive the username from login page
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // don't forget the widget!
            Text('Hello ${widget.receiveUsername}!',
            style: const TextStyle(fontSize: 24, fontWeight:FontWeight.bold),)
          ],
        ),),
    );
  }
}