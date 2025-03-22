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
  var personalTests = [];
  // fetch all the tests from the db
  Future getAllTests() async{
    var list = await _networkingManager.getAllTests(widget.patientId);
    testList = list;
    //personalTests = list.where((i) => i['patient_id']).toList();
    personalTests = testList.where((test) => 
        test['patient_id'] == widget.patientId // Match your API's key name
      ).toList();
    return list;
  }
  // var personalTests = testList


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tests'),),
      body: FutureBuilder(
        future: getAllTests(), 
        builder: (context, snapshot){
          return ListView.builder(
            itemCount: personalTests.length,
            itemBuilder: (context, index)=>ListTile(
              title: Text(personalTests[index]['category']),
              subtitle: Text(personalTests[index]['date']),
              onTap:(){
                Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestInfo(testId: personalTests[index][''])
                            ),
                        );
              }

            ));
        })
    );
  }
}