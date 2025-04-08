import 'package:flutter/material.dart';
import 'package:sencare/addPatient.dart';
import 'package:sencare/patientInfo.dart';
import 'package:sencare/editpatient.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sencare/networkingManager.dart';
import 'package:sencare/patientSearchDelegate.dart';

// define enum for filter

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
  bool _isLoading = true;
  String _errorMessage = '';
  final NetworkingManager _networkingManager = NetworkingManager();
  final List<String> conditions = ['Critical', 'Normal'];
  List<String> selectedCondition = [];

  
  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  
  // patientList
  List<dynamic> patients = [];

  void deletePatient(String patientId) async{
    try {
      Navigator.of(context).pop();
      setState(() {
        _isLoading = true;
      });
      await _networkingManager.removePatient(patientId);
    
      fetchPatients();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Patient deleted successfully"),
        backgroundColor: Colors.green)
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete patient: $error"),
        backgroundColor: Colors.red)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterPatientList = patients.where((filterPatient){
      return selectedCondition.isEmpty || selectedCondition.contains(filterPatient['condition']);
    }).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //title: const Text('Patient List'),
        actions: [
          IconButton(
            onPressed: (){
              showSearch(context: context, delegate: PatientSearchDelegate());
            }, 
          icon: Icon(Icons.search))
      ],),
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
            const SizedBox(
              height: 10.0,
            ),
            // filter to filter the patients
            Wrap(
              spacing: 10.0,
              children: conditions.map((condition)=>FilterChip(
                label: Text(condition), 
                selected: selectedCondition.contains(condition),
                onSelected: (selected){
                  setState(() {
                    if (selected){
                      selectedCondition.add(condition);
                    }
                    else {
                      selectedCondition.remove(condition);
                    }
                  });

                })).toList()
              
            ),
            const SizedBox(
              height: 10.0,
            ),
            
            // swipeable, to edit and delete(should have a alert dialog)
            Expanded(
              child: _isLoading? Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              :patients.isEmpty?
              Center(child: Text('No patients fpund'))

              :RefreshIndicator(onRefresh: ()async => fetchPatients(), 
              child: ListView.builder(
              itemCount: filterPatientList.length,
              itemBuilder: (_, int index) {
                final patient = filterPatientList[index];
                return Slidable(
                    key: Key(
                      index.toString(),
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditPatient(patientId: patient['_id'])));
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit_square,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            // display delete logic here
                            // list.removeAt(index)
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm Delete"),
                                  content: Text(
                                      "Are you sure you want to delete this patient?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deletePatient(patient['_id']);
                                     
                                      },
                                      child: Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Card(
                      color: patient['condition'] == 'Critical'?Color.fromARGB(175, 250, 151, 145): Color.fromARGB(255, 191, 222, 189),
                       
                      child: ListTile(
                      onTap: () {
                        
                        // later this will pass the id to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientInfo(patientId: patient['_id'])
                            ),
                        ).then((_){
                          fetchPatients();
                        });
                      },
                      title: Text("${patient['name']['first']} ${patient['name']['last']}"), 
                      subtitle: Text('Room: ${patient['room']}'),
                    ),
                    )
                    );
                //
              },
            ))
          ),

            // button to add button
            ElevatedButton(
                onPressed: () {
                  // press to nagivate to addPatient
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPatient()))
                      .then((_){
                        fetchPatients();
                      });
                },
                child: const Text("Add Patient"))
          ],
        ),
      ),
    );
  }

  void fetchPatients() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });
    try{
      final patientliat = await _networkingManager.getAllPatient();
      setState(() {
        patients = patientliat;
        _isLoading = false;
      });
    }catch(error){
      setState(() {
        _errorMessage = 'Failed to load patients: ${error.toString()}';
        _isLoading = false;
      });
    }
  
  }
}
