import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sencare/patientObject.dart';


class NetworkingManager {
  Future<List<String>> getAllPatient(String name) async {
    http.Response response = 
    await http.get(Uri.parse('http://172.16.7.126:3000/api/patients'));

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    }else {
      List<String> list = [];
      return list;
    }
  }

  // Future<PatientObject> getPatient(String name){
  //   http.Response response = 
  //   await http.get

  // }
}