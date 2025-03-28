import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sencare/networkingManager.dart';
import 'package:sencare/testObject.dart';
// this screen should be stateless since it only displays the result
class TestInfo extends StatefulWidget{
  final String testId;
  final String patientId;
  const TestInfo({Key? key, required this.testId, required this.patientId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    
    return _TextInfoState();
  }
}

class _TextInfoState extends State<TestInfo> {
  var testObject = TestObject(Reading(0,0,0.0,0,0), "", "", "", "", "", "");
  final NetworkingManager _networkingManager = NetworkingManager();
  Future getTestById(String patientId, String testId) async{
    testObject = await _networkingManager.getTestById(patientId, testId);
    print('patientid IN INFO PAGE: ${widget.patientId}');
    print('testid IN INFO PAGE: ${widget.testId}');
    print('test category: ${testObject.category}');
    print('test reading: ${testObject.reading.bloodOxygen}');
    return testObject;
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text('Test Info'),),
      body: FutureBuilder(
          future: getTestById(widget.patientId,widget.testId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Category: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  // read from passed object
                  child:
                      Text(testObject.category,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Nurse: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  // read from passed object
                  child: Text(
                    testObject.nurseName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Date: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  // read from passed object
                  child: Text(
                    testObject.date,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      
              
        } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error loading test data",
                    style: TextStyle(fontSize: 18, color: Colors.redAccent),)
                  ],
                ),

              );
            } 
          } ),
    );
  }

}