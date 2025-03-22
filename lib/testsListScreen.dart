import 'package:flutter/material.dart';
import 'package:sencare/testAddScreen.dart';
import 'package:sencare/testInfoScreen.dart';
import 'package:sencare/networkingManager.dart';
// this screen should be stateful

class TextListScreen extends StatefulWidget{
  final String patientId;
  const TextListScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TextListState();
  }
}

class _TextListState extends State<TextListScreen>{
  final NetworkingManager _networkingManager = NetworkingManager();
  var testList = [];
  // fetch all the tests from the db
  Future getAllTests() async{
    var list = await _networkingManager.getAllTests(widget.patientId);
    testList = list;
    return list;
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tests'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
              itemCount: testList.length,
              itemBuilder: (_, int index) {
                return ListTile(
                  onTap: () {
                    // later this will pass the id to the next screen
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TestInfo()));
                  },
                  title: Text('Test $index'),
                );
              },
            ),),

            // button to add button
            ElevatedButton(
                onPressed: () {
                  // press to nagivate to addPatient
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TestAdd(patientId: widget.patientId)));
                },
                child: const Text("Add Tests"))
          ],
        ),),
    );
  }
}