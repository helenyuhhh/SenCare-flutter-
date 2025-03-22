// handles all the api call here
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sencare/patientObject.dart';


class NetworkingManager {

static const String baseUrl = 'http://172.16.7.126:3000/api';
  
  Future<List<dynamic>> getAllPatient() async {
    try{
      http.Response response = 
            await http.get(Uri.parse('$baseUrl/patients'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
    }else {
      throw Exception('Failed to load patients: ${response.statusCode}');
    }
    }catch(error){
      print('Error fetching patient: $error');
      return [];
    }
  }


  Future<List<dynamic>> getPatientByName(String name) async {
    try{
      http.Response response = 
      await http.get(Uri.parse('$baseUrl/patients?name=$name'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }else {
      throw Exception("Failed to find patient ${response.statusCode}");
      
    }
    }catch(error){
      print('Error searching patient: $error');
      return [];
    }
    
  }

  // Future<PatientObject> getPatient(String name){
  //   http.Response response = 
  //   await http.get

  // }


}