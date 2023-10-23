 import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
               decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
               decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                )
              ),

              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {  },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}