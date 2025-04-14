import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sencare/loginScreen.dart';

void main() {
  group("test login widget", () {
    // test ui
    testWidgets("Display login widget", (tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));
      expect(find.text('SenCare'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      // test how many widgets contains Username and Passwprd
      expect(find.text('Username'), findsNWidgets(2));
      expect(find.text('Password'), findsNWidgets(2));
      // test how many textinput
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
    // test user login
  });
}
