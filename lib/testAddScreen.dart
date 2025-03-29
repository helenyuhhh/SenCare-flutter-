import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:sencare/testsListScreen.dart';
import 'package:sencare/networkingManager.dart';
import 'package:sencare/testObject.dart';

const List<String> _testNames = <String>[
  'Heartbeat Rate',
  'Blood Pressure',
  'Blood Oxygen Level',
  'Respiratory Rate',
];
class TestAdd extends StatefulWidget {
  final String patientId;
  const TestAdd({Key? key, required this.patientId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TestAdd();
  }
}

class _TestAdd extends State<TestAdd>{
  TextEditingController valueController = TextEditingController();// remove later
  TextEditingController nurseController = TextEditingController();
  TextEditingController sysController = TextEditingController();// sys
  TextEditingController diaController = TextEditingController();// dia
  TextEditingController heartBeatController = TextEditingController();// heartbeat
  TextEditingController resController = TextEditingController();// res
  TextEditingController bloxyController = TextEditingController();// bloodoxy
  String testType = _testNames[0];
  String testDateTime = "";
  String type = "Test"; // won't be changed
  final NetworkingManager _networkingManager = NetworkingManager();
  bool _isLoading = false;
  bool _isCritical = false;
  String _errorMsg = "";
  TestObject newTest = TestObject(Reading(0,0,0.0,0,0), "", "", "", "", "", "");
  // set for test title
  String valueTitle(){
    switch(testType){
      case "Heartbeat Rate":
        return "Heartbeat Rate: ";
      case 'Respiratory Rate':
        return 'Respiratory rate: ';
      case 'Blood Oxygen Level':
        return 'Blood Oxygen Level:  ';
      default:
        return "No Test found";
    }

  }
  // add ui adjust inside build

  
  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Test'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // scroll picker for tests
            Row(
              children: [
                Text(
                  "Select Test", 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: DropdownButton<String>(
                    value: testType,
                    onChanged: (String? newValue) {
                      setState(() {
                        testType = newValue!;
                      });
                    },
                    items: _testNames.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),),
                      );
                    }).toList(),
                  ),
                ),
              ],

            ),
            SizedBox(height: 10,),
            Text('Chosen test: $testType'),
            // value
            if (testType == 'Blood Pressure') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Systolic: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: TextField(
                      controller: sysController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'value'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Diastolic: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: TextField(
                      controller: valueController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'value'),
                    ),
                  ),
                ],
              ),
          ]
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    valueTitle(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: TextField(
                      controller: valueController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'value'),
                    ),
                  ),
                ],
              ),
              
          ],
            
              SizedBox(
                height: 10,
              ),
            // date
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Date: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                      onPressed: () {
                        picker.DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2010, 1, 1, 00, 00),
                            maxTime: DateTime(2100, 12, 31, 23, 59),
                            onChanged: (date) {
                          print(
                              'change $date in time zone ${date.timeZoneOffset.inHours}');
                        }, onConfirm: (date) {
                          setState(() {
                            testDateTime = date.toString();
                          });
                          
                          print('confirm $date');
                        }, locale: picker.LocaleType.en);
                      },
                      child: Text(
                        'Pick time',
                        style: TextStyle(color: Colors.blue),
                      )),
                ],
              ),
              // test date and time string
              Text('Choosen date: $testDateTime'),
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
                    child: TextField(
                      controller: nurseController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Nurse'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              IconButton(onPressed: (){
                    // 
                    Navigator.pop(context,
                      MaterialPageRoute(builder: (context) => TextListScreen(patientId: widget.patientId)));
                  }, 
                  icon: Icon(Icons.add_to_queue_rounded, size: 72))

              
            // nurse
          ],
        ),),
    );
  }

}