import 'dart:math';
import 'package:sencare/patientObject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:sencare/patientListScreen.dart';
import 'package:sencare/patientObject.dart';
import 'package:sencare/networkingManager.dart';
enum Gender { male, female }

enum Condition { normal, critical }

class AddPatient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddPatientState();
  }
}

class _AddPatientState extends State<AddPatient> {
  final NetworkingManager _networkingManager = NetworkingManager();
  bool _isLoading = false;
  String _errorMessage = "";
  //var picUrl = "https://randomuser.me/api/portraits/med/women/50.jpg";
  PatientObject newPatient = PatientObject(Name("", ""), 0, "", "", "", "", "", "", "");
  // controller for first name
  final TextEditingController fnameController = TextEditingController();
  // for last name
  final TextEditingController lnameController = TextEditingController();
  // for age
  final TextEditingController ageController = TextEditingController();
  // for room
  final TextEditingController roomController = TextEditingController();
  // weight
  final TextEditingController weightController = TextEditingController();
  // height
  final TextEditingController heightController = TextEditingController();
  // radio button for gender and condition
  Gender? _gender = Gender.male;
  Condition? _condition = Condition.normal;
  String dateTimeStr = "";
  String getGenderString(Gender? gender) {
    switch (gender) {
      case Gender.male:
        return "Male";
      case Gender.female:
        return "Female";
      default:
        return "Not selected";
    }
  }
  String getConditionString(Condition? condition) {
    switch (condition) {
      case Condition.normal:
        return "Normal";
      case Condition.critical:
        return "Critical";
      default:
        return "Not selected";
    }
  }
  String getImgLink(){
    final randomInt = Random().nextInt(98)+1;
    final chosenGender = _gender == Gender.male? "men" : "women";
    return "https://randomuser.me/api/portraits/med/$chosenGender/$randomInt.jpg";
  }
  // date picker
  bool validInput(){
    if (fnameController.text.isEmpty || lnameController.text.isEmpty
    || ageController.text.isEmpty || roomController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please input value!";
      });
      return false;
    }
    else {
      try{
        int.parse(ageController.text);
      }catch(error){
        setState(() {
          _errorMessage = "Age must be an integer!";
        });
        return false;
        
      }
    }
    return true;
    
  }

  Future<void> addNewpatient()async{
    if (!validInput()){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage),
        backgroundColor: Colors.red)
      );
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });
    try{
      final newPatient = PatientObject(
        Name(fnameController.text, lnameController.text), 
        int.parse(ageController.text), 
        getGenderString(_gender), 
        roomController.text, 
        getConditionString(_condition), 
        weightController.text, 
        heightController.text, 
        dateTimeStr.isNotEmpty ? dateTimeStr : DateTime.now().toString(),
        getImgLink());
        await _networkingManager.addPatient(newPatient);
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Patient added successfully!"),
        backgroundColor: Colors.green)
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PatientListScreen("Admin")));
    }catch (error){
      print(getGenderString(_gender));
      print(getImgLink());
      print(getConditionString(_condition));
      print(dateTimeStr);
      _errorMessage = "Failed to add patient";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage),
        backgroundColor: Colors.red)
      );
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Patient')),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // first name tag and text field
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "First Name: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: TextField(
                      controller: fnameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First Name'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              // last name and text field
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Last Name: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: TextField(
                      controller: lnameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Last Name'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              // age label and text field
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Age: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: TextField(
                      controller: ageController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Age'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              // gender label and text field
              Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Gender: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text("Male"),
                        leading: Radio<Gender>(
                          value: Gender.male,
                          groupValue: _gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _gender = value;
                              
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text("Female"),
                        leading: Radio<Gender>(
                          value: Gender.female,
                          groupValue: _gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _gender = value;
                             
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ]),
              // just for testing the gender string, can be used for store data in future
              // Text('Chosen gender: ${getGenderString(_gender)}'),
              SizedBox(
                height: 5,
              ),
              // for room:
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Room: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: TextField(
                      controller: roomController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Room'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              // for weight and height
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Weight: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: TextField(
                      controller: weightController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Weight'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Height: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: TextField(
                      controller: heightController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Height'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              // for condition
              Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Condition: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text("Normal"),
                        leading: Radio<Condition>(
                          value: Condition.normal,
                          groupValue: _condition,
                          onChanged: (Condition? value) {
                            setState(() {
                              _condition = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text("Critical"),
                        leading: Radio<Condition>(
                          value: Condition.critical,
                          groupValue: _condition,
                          onChanged: (Condition? value) {
                            setState(() {
                              _condition = value;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ]),
              // just for testing the gender string, can be used for store data in future
              // Text('Chosen condition: ${getConditionString(_condition)}'),
              SizedBox(
                height: 5,
              ),
              // for date
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
                            dateTimeStr = date.toString();
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
              Text('Choosen date: $dateTimeStr'),
              // add patient button
              Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(onPressed: (){
                    // 
                    addNewpatient();
                  }, 
                  icon: Icon(Icons.group_add, size: 72))
                ),

            ],
          )),
    );
  }
}
