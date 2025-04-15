import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sencare/patientListScreen.dart';

final mockPatients = [
    {
      'id': '1',
      'name': {'first': 'Sam', 'last': 'Smith'},
      'age': 35,
      'gender': 'Male',
      'room': "203A",
      'condition': 'Normal',
      'weight': '176 lb',
      'height': '5.6 ft',
      'date': '2023-01-01',
      'picture': 'http:223.com/me'
    },
    {
      'id': '2',
      'name': {'first': 'Tom', 'last': 'Smith'},
      'age': 35,
      'gender': 'Male',
      'room': "203A",
      'condition': 'Critical',
      'weight': '176 lb',
      'height': '5.6 ft',
      'date': '2023-01-02',
      'picture': 'http:223.com/he'
    }
  ];
void main(){
  String url = "http://172.16.7.102:3000/api";
  testWidgets('Filter patients by critical', (WidgetTester tester) async{
    final mockClient = MockClient((request) async{
      if (request.url.toString() == '$url/patients'){
        return http.Response(jsonEncode(mockPatients), 200);
      }
      return http.Response('Patient not found', 404);
    });
    await http.runWithClient(() async{
      await tester.pumpWidget(MaterialApp(home:PatientListScreen('admin')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Critical'));
      expect(find.text('Tom Smith'), findsOneWidget);
    }, () => mockClient);
  });

  testWidgets('Filter patients by normal', (WidgetTester tester) async{
    final mockClient = MockClient((request) async{
      if (request.url.toString() == '$url/patients'){
        return http.Response(jsonEncode(mockPatients), 200);
      }
      return http.Response('Patient not found', 404);
    });
    await http.runWithClient(() async{
      await tester.pumpWidget(MaterialApp(home:PatientListScreen('admin')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Normal'));
      expect(find.text('Sam Smith'), findsOneWidget);
    }, () => mockClient);
  });


}