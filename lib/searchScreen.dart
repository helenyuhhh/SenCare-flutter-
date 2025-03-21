import 'package:flutter/material.dart';
import 'package:sencare/patientSearchDelegate.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _SearchScreenState();
  }

}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Patient'),
        actions: [
          IconButton(
            onPressed: (){
              showSearch(context: context, delegate: PatientSearchDelegate());

          }, icon: const Icon(Icons.search))
        ],
      ),
      body: const Text("Search For Patients"),

    );
  }
}