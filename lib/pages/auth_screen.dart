import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:paytyme/Auth/login.dart';
import 'package:paytyme/resources/authentication.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  performBiometricsAuth() async {
    print("performBiometricsAuth");
    if (await _isBiometricAvailable()) {
      await _getListOfBiometricTypes();
      await _authenticateUser();
    } else {
      Flushbar(
        backgroundColor: Colors.orange,
        title: "PAYTYME",
        message: "Biometrics Authentication is not available on this device",
        duration: Duration(seconds: 10),
      )..show(context);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage()),
      // );
      navigateUser();
      //HomeScreen();
    }
  }

  //For checking if any type of biometric authentication hardware is available in the device
  Future<bool> _isBiometricAvailable() async {
    bool isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return isAvailable;

    isAvailable
        ? print('Biometric is available!')
        : print('Biometric is unavailable.');

    return isAvailable;
  }

  //To get the list of available biometric types
  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    print(listOfBiometrics);
  }

  // For authenticating the user using biometrics
  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate to continue",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    isAuthenticated
        ? print('User is authenticated!')
        : print('User is not authenticated.');
    // if biometrics is available but the user does not auth with it
    // then the app will close... i think :)
    if (isAuthenticated) {
      navigateUser();
      //HomeScreen();
    } else {
      Flushbar(
        backgroundColor: Colors.orange,
        title: "PAYTYME",
        message: "You declined Authentication. Exiting...",
        duration: Duration(seconds: 2),
      )..show(context).then(
          (value) => Future.delayed(
            const Duration(milliseconds: 1000),
            () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          ),
        );
    }
  }

  AuthMethods _authMethods = AuthMethods();

  navigateUser() {
    // checking whether user already loggedIn or not
    FirebaseAuth.instance.currentUser().then((currentUser) {
      if (currentUser == null) {
        Timer(
            Duration(seconds: 2),
            () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                ));
      } else {
        _authMethods.signOut().then((value) => Timer(
              Duration(seconds: 1),
              () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Login()),
              ),
            ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    performBiometricsAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            child: Image.asset('assets/splash.jpg'),
          ),
          
        ],
      ),
    );
  }
}
