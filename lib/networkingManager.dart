// handles all the api call here
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sencare/patientObject.dart';


class NetworkingManager {
  // run ifconfig | grep "inet " | grep -v 127.0.0.1' to check ip address
// school base url: switch this when presentation http://10.24.48.115:3000/api
// home network address: http://172.16.7.102:3000/api
// school: static const String baseUrl = 'http://10.24.48.115:3000/api';
static const String baseUrl = 'http://172.16.7.102:3000/api';
  // fetch all patients -- PatientListScreen
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
  // fetch all tests
  Future<List<dynamic>> getAllTests(String id) async {
    try{
      http.Response response = 
            await http.get(Uri.parse('$baseUrl/patients/$id/tests'));
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
  // get all patients by name
  Future<List<dynamic>> getAllPatientByName(String name) async {
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
  // get patient by searching name -- SearchScreen
  Future<PatientObject> getPatientByName(String name) async {
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
      return PatientObject(Name("", ""), 0, "", "", "", "", "", "");
     
    }
  }
  // get patient by id -- PatientinfoScreen 
  Future<PatientObject> getPatientById(String id) async {
    try{
      http.Response response = 
      await http.get(Uri.parse('$baseUrl/patients/$id'));

    if (response.statusCode == 200) {
      var jsonObj = jsonDecode(response.body);
      var fname = jsonObj['name']['first'] as String;
      var lname = jsonObj['name']['last'] as String;
      var age = jsonObj['age'] as int;
      var gender = jsonObj['gender'] as String;
      var room = jsonObj['room'] as String;
      var condition = jsonObj['condition'] as String;
      var weight = jsonObj['weight'] as String;
      var height = jsonObj['height'] as String;
      var picture = jsonObj['picture'];
      return PatientObject(Name(fname, lname), age, gender, room, condition, weight, height, picture);

    }else {
      throw Exception("Failed to find patient ${response.statusCode}");
      
    }
    }catch(error){
      print('Error searching patient with id: $error');
      return PatientObject(Name("", ""), 0, "", "", "", "", "", "");
    }
  }



}