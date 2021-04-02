import 'dart:async';

import 'package:flutter/material.dart';
import 'package:paytyme/pages/auth_screen.dart';




class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState(); 

    navigateUser();
  }

  navigateUser() {
     
      {
        Timer(
            Duration(seconds: 5),
            () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>AuthScreen()),
                ));
      } 
      
    
  }
  @override
  Widget build(BuildContext context) {
    // design the ui of this screen
    return Scaffold(
      backgroundColor: Colors.white,
      body: 
        Container(
          child: Image.asset('assets/splash.jpg'),
        ),
       
     
    );
  }
}


