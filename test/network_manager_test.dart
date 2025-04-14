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
  // mock test lists
  final mockTests = [
    {
      "reading": {"blood_oxygen": 0.94},
      "_id": "6736cc45f73650203f76e0a8",
      "patient_id": "6717baff3d4cc3631620fa99",
      "date": "2024-11-08T00:00:00.000Z",
      "nurse_name": "Emma",
      "type": "Test",
      "category": "Blood Oxygen Level",
      "id": "4"
    },
    {
      "reading": {"blood_oxygen": 0.88},
      "_id": "6736cc45f73650203f70909",
      "patient_id": "6717baff3d4cc3634577799",
      "date": "2024-11-08T00:00:00.000Z",
      "nurse_name": "Emma",
      "type": "Test",
      "category": "Blood Oxygen Level",
      "id": "5"
    }
  ];
  final mockTest = {
    "reading": {"blood_oxygen": 0.94},
    "_id": "12",
    "patient_id": "123",
    "date": "2024-11-08T00:00:00.000Z",
    "nurse_name": "Emma",
    "type": "Test",
    "category": "Blood Oxygen Level",
    "id": "4"
  };

  group("Test API", () {
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
    test('Delete a patient by id', () async {
      const patientID = "123";
      final mockClient = MockClient((request) async {
        if (request.url.toString() == '$url/patients/123' &&
            request.method == 'DELETE') {
          return http.Response('Patient deleted', 200);
        }
        return http.Response('Error', 400);
      });
      await http.runWithClient(() async {
        final manager = NetworkingManager();
        await expectLater(manager.removePatient(patientID), completes);
      }, () => mockClient);
    });
    test('Get all the tests', () async {
      const patientID = '123';
      final mockClient = MockClient((request) async {
        if (request.url.toString() == '$url/patients/123/tests') {
          return http.Response(jsonEncode(mockTests), 200);
        }
        return http.Response('Cannot find tests', 404);
      });
      await http.runWithClient(() async {
        final manager = NetworkingManager();
        final tests = await manager.getAllTests(patientID);
        expect(tests.length, 2);
      }, () => mockClient);
    });
    test('Get test by id', () async {
      const patientID = '123';
      const testID = '12';
      final mockClient = MockClient((request) async {
        if (request.url.toString() == '$url/patients/123/tests/12') {
          return http.Response(jsonEncode(mockTest), 200);
        }
        return http.Response('Failed to find test', 404);
      });
      await http.runWithClient(() async {
        final manaer = NetworkingManager();
        final test = await manaer.getTestById(patientID, testID);
        expect(test.reading.bloodOxygen, 0.94);
      }, () => mockClient);
    });
    test('Add new test', () async {
      const patientID = '123';
      final mockClient = MockClient((request) async {
        if (request.url.toString() == '$url/patients/123/tests' &&
            request.method == 'POST') {
          return http.Response(
              jsonEncode({
                "reading": {"blood_oxygen": 0.94},
                "patient_id": "123",
                "date": "2024-11-08T00:00:00.000Z",
                "nurse_name": "Emma",
                "type": "Test",
                "category": "Blood Oxygen Level",
                "id": "4"
              }),
              201);
        }
        return http.Response('Failed to add new test', 401);
      });
      http.runWithClient(() async{
        final manager = NetworkingManager();
        await expectLater(
          manager.addTest(patientID, 
          TestObject(Reading(0, 0, 0.94, 0, 0), patientID, 
          "2024-11-08T00:00:00.000Z", "Emma", "Test", 
          "Blood Oxygen Level", "4")), completes);
      }, () => mockClient);
    });
  });
}
