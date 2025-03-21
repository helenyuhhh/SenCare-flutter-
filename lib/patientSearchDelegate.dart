import 'package:flutter/material.dart';
import 'package:sencare/networkingManager.dart';

class PatientSearchDelegate extends SearchDelegate{
  var patientList = [];
  Future getAllPatientsFromAPI(String searchTerm) async {
    var list = await NetworkingManager().getAllPatient(searchTerm);
    patientList = list;
    return list;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(
        onPressed: () {
          query = "";
          patientList = [];
        },
        icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      onPressed: (){
        Navigator.pop(context);
      },
      icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: getAllPatientsFromAPI(query), 
      builder: (context, snapshot){
        return ListView.builder(
          itemCount: patientList.length,
          itemBuilder:(context, index)=>ListTile(
            title: Text(patientList[index]),
            onTap: (){},

          ));
      });
  }
  @override Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return FutureBuilder(
      future: getAllPatientsFromAPI(query),
      builder: (context, snapshot){
        return ListView.builder(
          itemCount: patientList.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(patientList[index]),
            onTap:(){
              Navigator.pop(context);
              Navigator.pushNamed(context, 'patientInfo',
              arguments: [1, patientList[index] as String, 0.0, 0.0]);
            }

          ));
      });

  }
}