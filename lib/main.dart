import 'package:flutter/material.dart';
import 'package:sencare/loginScreen.dart';
import 'package:sencare/patientListScreen.dart';
import 'package:sencare/searchScreen.dart';
import 'package:sencare/patientInfo.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sencare',
      routes:{
        '/': (context) => LoginScreen(),
        '/search':(context) => SearchScreen(),
        'patientInfo': (context) => PatientInfo(),

      }
    );
  }
}
