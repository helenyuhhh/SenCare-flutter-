import 'package:flutter/material.dart';
import 'package:sencare/testAddScreen.dart';
import 'package:sencare/testInfoScreen.dart';
// this screen should be stateful

class TextListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TextListState();
  }
}

class _TextListState extends State<TextListScreen>{
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
              itemCount: 5,
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
                      MaterialPageRoute(builder: (context) => TestAdd()));
                },
                child: const Text("Add Tests"))
          ],
        ),),
    );
  }
}