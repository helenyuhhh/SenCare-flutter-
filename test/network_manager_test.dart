// test the network function here
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sencare/networkingManager.dart';
import 'package:sencare/patientObject.dart';
import 'package:sencare/testObject.dart';
import 'network_manager_test.mocks.dart' as mocks;

// generate MocKClient
@GenerateMocks([http.Client])
void main() {
  String url = "http://172.16.7.102:3000/api";
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
      'condition': 'Normal',
      'weight': '176 lb',
      'height': '5.6 ft',
      'date': '2023-01-02',
      'picture': 'http:223.com/he'
    }
  ];
  group("Test API", () {
    final mockPatient = {
      'id': '123',
      'name': {'first': 'Sam', 'last': 'Smith'},
      'age': 35,
      'gender': 'Male',
      'room': "203A",
      'condition': 'Normal',
      'weight': '176 lb',
      'height': '5.6 ft',
      'date': '2023-01-01',
      'picture': 'http:223.com/me'
    };
    test('Get patient list', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString() == '$url/patients') {
          return http.Response(jsonEncode(mockPatients), 200);
        }
        return http.Response('Patients not found', 404);
      });
      await http.runWithClient(() async {
        final networkManager = NetworkingManager();
        final patients = await networkManager.getAllPatient();
        expect(patients.length, 2);
        expect(patients[0]['name']['first'], 'Sam');
      }, () => mockClient);
    });
    test('Get patient by ID', () async {
      const patientID = "123";
      final mockClient = MockClient((request) async {
        if (request.url.toString() == '$url/patients/123') {
          return http.Response(jsonEncode(mockPatient), 200);
        }
        return http.Response('Patients not found', 404);
      });
      await http.runWithClient(() async {
        final manager = NetworkingManager();
        final patient = await manager.getPatientById(patientID);
        expect(patient.name.first, 'Sam');
      }, () => mockClient);
    });
    test('Add new patient', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString() == '$url/patients/' &&
            request.method == 'POST') {
          return http.Response(
              jsonEncode({
                'id': '123',
                'name': {'first': 'Alice', 'last': 'Smith'},
                'age': 26,
                'gender': 'Female',
                'room': '202A',
                'condition': 'Normal',
                'weight': '126 lb',
                'height': '5.3 ft',
                'date': '2023-1-1',
                'picture': 'www.find.me'
              }),
              201);
        }
        return http.Response('Error', 400);
      });
      await http.runWithClient(() async {
        final manager = NetworkingManager();
        await expectLater(
          manager.addPatient(PatientObject(Name('Alice', 'Smith'), 26, "Female",
              "202A", "Normal", "126 lb", "5.3 ft", "2023-1-1", "www.find.me")),
          completes,
        );
      }, () => mockClient);
    });
  });
}
