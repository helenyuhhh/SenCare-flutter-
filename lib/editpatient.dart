import 'package:flutter/material.dart';
import '';

class EditPatient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditPatient();
  }
}

class _EditPatient extends State<EditPatient> {
  // room, age, weight. height
  final TextEditingController _changeRoom = TextEditingController();
  final TextEditingController _changeAge = TextEditingController();
  final TextEditingController _changeWeight = TextEditingController();
  final TextEditingController _changeHeight = TextEditingController();
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
                onPressed: () {
                  //   Navigator.push(context,
                  //  MaterialPageRoute(builder: (context) =>
                  //  AddPatient()))
                },
                child: const Text("Save"))
          ],
        ),
      ),
    );
  }
}
