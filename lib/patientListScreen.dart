import 'package:flutter/material.dart';
import 'package:sencare/addPatient.dart';
import 'package:sencare/patientInfo.dart';
// define enum for filter
enum PatientFilter { critical, normal }

class PatientListScreen extends StatefulWidget {
  // variable to receive the passed username
  final String receiveUsername;
  // constructor
  const PatientListScreen(this.receiveUsername, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _PatientListState();
  }
}

class _PatientListState extends State<PatientListScreen> {
  // define a search bar controller
  SearchController _searchBarController = SearchController();
  // a filter set for filter the oatienrs with conditions
  Set<PatientFilter> filters = <PatientFilter>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // don't forget the widget!
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hello ${widget.receiveUsername}!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // a search bar
            SizedBox(
              height: 15,
            ),
            SearchBar(
              controller: _searchBarController,
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onTap: () {
                // search function
              },
              leading: const Icon(Icons.search),
            ),
            const SizedBox(
              height: 10.0,
            ),
            // filter to filter the patients
            Wrap(
              spacing: 10.0,
              children: PatientFilter.values.map((PatientFilter patient) {
                return FilterChip(
                    label: Text(patient.name),
                    selected: filters.contains(patient),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          filters.add(patient);
                        } else {
                          filters.remove(patient);
                        }
                      });
                      // filter function
                    });
              }).toList(),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
                'Looking for ${filters.map((PatientFilter p) => p.name).join(', ')}'),
            // patient list
            // swipeable, to edit and delete(should have a alert dialog)
            Expanded(
              child: ListView.builder(
              itemCount: 20,
              itemBuilder: (_, int index) {
                return ListTile(
                  onTap: () {
                    // later this will pass the id to the next screen
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PatientInfo()));
                    
                  },
                  title: Text('Patient $index'),
                );
              },
            )),

            // button to add button
            ElevatedButton(
                onPressed: () {
                  // press to nagivate to addPatient
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddPatient()));
                },
                child: const Text("Add Patient"))
          ],
        ),
      ),
    );
  }
}
