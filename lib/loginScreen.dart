import 'package:flutter/material.dart';
import 'package:sencare/loginScreen.dart';
import 'package:sencare/patientListScreen.dart';
// this is the login screen for the app
class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return _LoginState();
  }
  
}

class _LoginState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var validAuth = false;
  void _checkInput(){
    if ( _usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      if ((_usernameController.text == 'Admin' && _passwordController.text == 'admin')){
        validAuth = true;
        // hide the back button
        Navigator.pushReplacement(
          context, 
         MaterialPageRoute(builder: (context) => PatientListScreen(_usernameController.text)));
      }
      else {
        validAuth = false;
      }
    } 
    if (validAuth == false){
      showDialog(
        context: context,
        builder: (context){
          return (
            AlertDialog(
              title: Text("Invalid username or password"),
              actions: [
                MaterialButton(onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('OK'),)
              ],
            )
          );

        }
        
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SenCare')
        ),
        body: Center(
          child: Column(
            children: [
              // Image
            Image.asset('assets/logo.png', width: 200, height: 200),
            // text for username
            const Text(
              'Username',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // textfield for username
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText:'Username' 
              ),
            ),
            const SizedBox(height: 20,),
            const Text(
              'Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // textfield for username
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText:'Password' 
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: _checkInput, 
            child: const Text('Login'))
            ]
            
            
          ),
        ),
      ),
    );
  }
}