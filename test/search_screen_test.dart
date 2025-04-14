import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sencare/searchScreen.dart'; 
import 'package:sencare/patientSearchDelegate.dart';

class MockPatientSearchDelegate extends Mock implements PatientSearchDelegate {}

void main(){
  group('Test search screen wighet', (){
    testWidgets('Test widgets', (tester) async{
      await tester.pumpWidget(MaterialApp(
        home: SearchScreen(),
      ));
      expect(find.byIcon(Icons.search), findsOne);
    });
    testWidgets('Test search delegate', (tester) async{
      await tester.pumpWidget(MaterialApp(home: SearchScreen()));
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);

    });
  });
}