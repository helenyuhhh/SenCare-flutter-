import 'package:flutter/material.dart';
import 'package:sencare/testAddScreen.dart';
import 'package:sencare/testInfoScreen.dart';
import 'package:sencare/networkingManager.dart';

// this screen should be stateful
class TextListScreen extends StatefulWidget {
  final String patientId;
  const TextListScreen({Key? key, required this.patientId}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return _TextListState();
  }
}

class _TextListState extends State<TextListScreen> {
  final NetworkingManager _networkingManager = NetworkingManager();
  var testList = [];
  var personalTests = [];
  
  Future getAllTests() async {
    var list = await _networkingManager.getAllTests(widget.patientId);
    testList = list;
    personalTests = testList
      .where((test) =>
        test['patient_id'] == widget.patientId
      )
      .toList();
    return list;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tests'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => getAllTests(),
              child: FutureBuilder(
                future: getAllTests(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error loading tests"));
                  } else if (personalTests.isEmpty) {
                    return Center(child: Text("No tests found"));
                  } else {
                    return ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: personalTests.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          title: Text(personalTests[index]['category']),
                          subtitle: Text(personalTests[index]['date']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TestInfo(
                                  testId: personalTests[index]['_id'],
                                  patientId: widget.patientId
                                )
                              ),
                            ).then((_) {
                              
                              setState(() {});
                            });
                          }
                        ),
                      )
                    );
                  }
                }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              onPressed: () {
                // press to navigate to addPatient
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestAdd(patientId: widget.patientId)
                  )
                ).then((_) {
                  // Refresh the list when returning from adding a test
                  setState(() {});
                });
              },
              icon: Icon(Icons.add_circle_rounded),
              iconSize: 75,
            ),
          )
        ],
      )
    );
  }
}