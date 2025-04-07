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

class _TestAdd extends State<TestAdd> {
  //TextEditingController valueController = TextEditingController();// remove later
  TextEditingController nurseController = TextEditingController();
  TextEditingController sysController = TextEditingController(); // sys
  TextEditingController diaController = TextEditingController(); // dia
  TextEditingController heartBeatController =
      TextEditingController(); // heartbeat
  TextEditingController resController = TextEditingController(); // res
  TextEditingController bloxyController = TextEditingController(); // bloodoxy
  String testType = _testNames[0];
  String testDateTime = "";
  String type = "Test"; // won't be changed
  final NetworkingManager _networkingManager = NetworkingManager();
  bool _isLoading = false;
  bool _isValidInput = false;
  bool _isCritical = false;
  String _errorMsg = "";
  TestObject newTest =
      TestObject(Reading(0, 0, 0.0, 0, 0), "", "", "", "", "", "");
  // set for test title
  String valueTitle() {
    switch (testType) {
      case "Heartbeat Rate":
        return "Heartbeat Rate: ";
      case 'Respiratory Rate':
        return 'Respiratory rate: ';
      case 'Blood Oxygen Level':
        return 'Blood Oxygen Level:  ';
      case 'Blood Pressure':
        return 'Blood Pressure';
      default:
        return "No Test found";
    }
  }

  void checkInputAndState() {
    _isValidInput = false;
    _isCritical = false;
    _errorMsg = "";
    if (nurseController.text.isEmpty) {
      _errorMsg = "Please input nurse's name ! ";
      return;
    }
    if (testDateTime.isEmpty) {
      _errorMsg = "Please choose date and time ! ";
      return;
    }
    switch (testType) {
      case "Heartbeat Rate":
        if (heartBeatController.text.isEmpty) {
          _errorMsg = "Please enter value!";
          return;
        }
        try {
          int heartBeatValue = int.parse(heartBeatController.text);
          if (heartBeatValue > 300) {
            _errorMsg = "Value too large ! Please try again";
            return;
          }
          if (!(heartBeatValue >= 60 && heartBeatValue <= 100)) {
            _isCritical = true;
          }
        } catch (error) {
          _errorMsg = "Invalid input!";
          return;
        }
        break;
      case 'Respiratory Rate':
        if (resController.text.isEmpty) {
          _errorMsg = "Please enter value!";
          return;
        }
        try {
          int resValue = int.parse(resController.text);
          if (resValue > 30) {
            _errorMsg = "Value too large ! Please try again";
            return;
          }
          if (!(resValue >= 12 && resValue <= 16)) {
            _isCritical = true;
          }
        } catch (error) {
          _errorMsg = "Invalid input!";
          return;
        }
        break;
      case 'Blood Oxygen Level':
        if (bloxyController.text.isEmpty) {
          _errorMsg = "Please enter value!";
          return;
        }
        try {
          double bOXValue = double.parse(bloxyController.text);
          if (bOXValue > 1.0 || bOXValue < 0.0) {
            _errorMsg = "Input should between 0-1";
            return;
          }
          if (!(bOXValue >= 0.95 && bOXValue <= 1.0)) {
            _isCritical = true;
          }
        } catch (error) {
          _errorMsg = "Invalid input!";
          return;
        }
        break;
      case 'Blood Pressure':
        if (sysController.text.isEmpty) {
          _errorMsg = "Systolic value should not be empty!";
          return;
        }
        if (diaController.text.isEmpty) {
          _errorMsg = "Diastolic value should not be empty!";
          return;
        }
        try {
          int sysValue = int.parse(sysController.text);
          int diaValue = int.parse(diaController.text);
          if (sysValue > 200 || diaValue > 200) {
            _errorMsg = "Blood pressure values too high ! Please try again";
            return;
          }

          if (sysValue < 120 && diaValue < 80) {
            _isCritical = true;
          }
        } catch (error) {
          _errorMsg = "Invalid input!";
          return;
        }
        break;
    }
    _isValidInput = true;
  }

  Future<void> addNewTest() async {
    checkInputAndState();
    if (!_isValidInput) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_errorMsg),
        backgroundColor: Colors.red,
      ));
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMsg = "";
    });
    try {
      int heartRate = 0;
      int respiratoryRate = 0;
      double bloodOxygen = 0.0;
      int systolic = 0;
      int diastolic = 0;
      switch (testType) {
        case "Heartbeat Rate":
          heartRate = int.parse(heartBeatController.text);
          break;
        case "Respiratory Rate":
          respiratoryRate = int.parse(resController.text);
          break;
        case "Blood Oxygen Level":
          bloodOxygen = double.parse(bloxyController.text);
          break;
        case "Blood Pressure":
          systolic = int.parse(sysController.text);
          diastolic = int.parse(diaController.text);
          break;
      }
      final newTest = TestObject(
          // heartb, res, blox, sys, dia
          Reading(
              heartRate,
              respiratoryRate,
              bloodOxygen,
              systolic,
              diastolic),
          widget.patientId,
          testDateTime,
          nurseController.text,
          type,
          testType,
          "1");
      await _networkingManager.addTest(widget.patientId, newTest);

      if (_isCritical) {
        await _networkingManager.updatePatient(widget.patientId,
            newCondition: "Critical");
      }
      else if (!_isCritical) {
        await _networkingManager.updatePatient(widget.patientId,
            newCondition: "Normal");

      }
      

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Patient added successfully ! "),
        backgroundColor: Colors.green,
      ));
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             TextListScreen(patientId: widget.patientId)));
    } catch (error) {
      _errorMsg = "Failed to add test!";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_errorMsg),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // scroll picker for tests
            Row(
              children: [
                Text(
                  "Select Test",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: DropdownButton<String>(
                    value: testType,
                    onChanged: (String? newValue) {
                      setState(() {
                        testType = newValue!;
                      });
                    },
                    items: _testNames
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
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
                      controller: diaController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'value'),
                    ),
                  ),
                ],
              ),
            ] else if (testType == 'Heartbeat Rate') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    valueTitle(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: TextField(
                      controller: heartBeatController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'value'),
                    ),
                  ),
                ],
              ),
            ] else if (testType == 'Respiratory Rate') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    valueTitle(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: TextField(
                      controller: resController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'value'),
                    ),
                  ),
                ],
              ),
            ] else if (testType == 'Blood Oxygen Level') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    valueTitle(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: TextField(
                      controller: bloxyController,
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
            IconButton(
                onPressed: () {
                  //
                  addNewTest();
                },
                icon: Icon(Icons.add_to_queue_rounded, size: 72))

            // nurse
          ],
        ),
      ),
    );
  }
}
