import 'package:flutter/material.dart';
// this should be stateless widget since it's just displaying, not changing
class PatientInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.person_2_outlined, size: 100),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Name: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Text(
                      // read from passed object
                      'Sample data'),
                    ),
                ],
              ),
              SizedBox(
                height: 5,
              )
          ],

        ),),

    );
  }
}
