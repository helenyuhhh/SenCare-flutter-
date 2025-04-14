import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sencare/editPatient.dart';

void main(){
  group('Test Edit Patient widget', (){
    const patientID = "123";
    testWidgets('Test widget', (tester) async{
      await tester.pumpWidget(MaterialApp(home:EditPatient(patientId: patientID,)));
      expect(find.text('Edit Patient'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(4));
      expect(find.byType(ElevatedButton), findsOneWidget);

    });

  });
}