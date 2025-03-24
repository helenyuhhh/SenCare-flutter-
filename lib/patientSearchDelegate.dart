import 'package:flutter/material.dart';
import 'package:sencare/networkingManager.dart';
import 'package:sencare/patientInfo.dart';

// in progress
class PatientSearchDelegate extends SearchDelegate {
  var patientList = [];
  Future getAllPatientsFromAPI(String searchTerm) async {
    var list = await NetworkingManager().getAllPatientByName(searchTerm);
    patientList = list;
    return list;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
            patientList = [];
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: getAllPatientsFromAPI(query),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: patientList.length,
              itemBuilder: (context, index) => ListTile(
                    title: Text(
                        "${patientList[index]['name']['first']} ${patientList[index]['name']['last']}"),
                    subtitle: Text(patientList[index]['room']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PatientInfo(
                                patientId: patientList[index]['_id'])),
                      );
                    },
                  ));
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List filteredPatients = patientList.where((patient) {
        String firstName = patient['name']['first'].toString().toLowerCase();
        String lastName = patient['name']['last'].toString().toLowerCase();
        String fullName = "$firstName $lastName";
        String searchQuery = query.toLowerCase();
        
        return firstName.contains(searchQuery) || 
               lastName.contains(searchQuery) || 
               fullName.contains(searchQuery);
      }).toList();
    return FutureBuilder(
        future: getAllPatientsFromAPI(query),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) => ListTile(
                  title: Text(
                      "${filteredPatients[index]['name']['first']} ${filteredPatients[index]['name']['last']}"),
                  subtitle: Text(filteredPatients[index]['room']),
                  onTap: () {
                    //Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PatientInfo(
                              patientId: filteredPatients[index]['_id'])),
                    );
                    //arguments: [1, patientList[index] as String, 0.0, 0.0]);
                  }));
        });
  }
}
