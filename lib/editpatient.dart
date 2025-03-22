import 'package:flutter/material.dart';
import 'package:sencare/patientInfo.dart';
import 'package:sencare/patientObject.dart';
import 'package:sencare/networkingManager.dart';

class EditPatient extends StatefulWidget {
  final String patientId;
  const EditPatient({Key? key, required this.patientId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EditPatient();
  }
}

class _EditPatient extends State<EditPatient> {
  late PatientObject _patient;
  // room, age, weight. height
  final TextEditingController _changeRoom = TextEditingController();
  final TextEditingController _changeAge = TextEditingController();
  final TextEditingController _changeWeight = TextEditingController();
  final TextEditingController _changeHeight = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = "";
  @override
  void dispose(){
    _changeRoom.dispose();
    _changeAge.dispose();
    _changeWeight.dispose();
    _changeHeight.dispose();
    super.dispose();
  }
  final NetworkingManager _networkingManager = NetworkingManager();
  Future<void> _saveChanges() async {
    try {
      await _networkingManager.updatePatient(
        widget.patientId, 
        newRoom: _changeRoom.text.isNotEmpty? _changeRoom.text : null,
        newAge: _changeAge.text.isNotEmpty? int.tryParse(_changeAge.text) : null,
        newWeight: _changeWeight.text.isNotEmpty? _changeWeight.text : null,
        newHeight: _changeHeight.text.isNotEmpty? _changeHeight.text : null,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Patient updated successfully!"))
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PatientInfo(patientId: widget.patientId)));
    }catch(error){
      setState(() {
        _errorMessage = "Failed to update";
      });
      print('patient id: ${widget.patientId}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update!'))
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Edit Patient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "New Room: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: TextField(
                    controller: _changeRoom,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Room Number'),
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
                  "New Age: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: TextField(
                    controller: _changeAge,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Age'),
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
                  "New Weight: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: TextField(
                    controller: _changeWeight,
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
                  "New Height: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: TextField(
                    controller: _changeHeight,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Height'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            
            ElevatedButton(
                onPressed: _saveChanges,
                child: const Text("Save"))
          ],
        ),
      ),
    );
  }
}
