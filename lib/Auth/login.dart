import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:paytyme/Auth/sign_up.dart';
import 'package:paytyme/pages/home_screen.dart';
import 'package:paytyme/resources/authentication.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailVerified = false;
  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  AuthMethods authMethods = AuthMethods();
  // performs signup
  void validateAndSubmit(context) async {
    print("performing login...");
    if (_validateAndSave()) {
      setState(() {
        _isLoading = true;
      });
      String userId = "";
      try {
        await authMethods.signIn(emailTextEditingController.text,
            passwordTextEditingController.text);
        await _checkEmailVerification(context);
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => HomeScreen()));

        print('Signed up user: $userId');
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  _checkEmailVerification(context) async {
    _isEmailVerified = await authMethods.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog(context);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _resentVerifyEmail() async {
    await authMethods.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resend link"),
              onPressed: () async {
                await _resentVerifyEmail();
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
      ),
      body: Stack(
        children: [
          _showCircularProgress(),
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.only(top: 35, left: 20.0, right: 20.0),
              child: Column(children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailTextEditingController,
                  decoration: InputDecoration(
                    labelText: 'EMAIL',
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  validator: (value) {
                    return value.isEmpty ? 'Email is required.' : null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: passwordTextEditingController,
                  decoration: InputDecoration(
                      labelText: 'PASSWORD',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue))),
                  obscureText: true,
                  validator: (value) {
                    return value.isEmpty ? 'Password is required.' : null;
                  },
                ),
                SizedBox(height: 5.0),
                Container(
                  alignment: Alignment(1.0, 0),
                  padding: EdgeInsets.only(top: 15.0, left: 20.0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return ForgotPassword();
                          });
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                GestureDetector(
                  onTap: () {
                    validateAndSubmit(context);
                  },
                  child: Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        shadowColor: Colors.blueAccent,
                        color: Colors.blue,
                        elevation: 7.0,
                        child: Center(
                            child: Text(
                          'LOGIN',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                      )),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
                  },
                  child: Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        shadowColor: Colors.blueAccent,
                        color: Colors.blue,
                        elevation: 7.0,
                        child: Center(
                            child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                      )),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailTextEditingController = TextEditingController();
  AuthMethods authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    resetPassword() async {
      if (emailTextEditingController.text.isNotEmpty) {
        authMethods.sendPasswordResetMail(emailTextEditingController.text);
        Flushbar(
          backgroundColor: Colors.orange,
          title: "PAYTYME",
          message: "Password reset email sent",
          duration: Duration(seconds: 10),
        )..show(context);
      }
    }

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        "Forgot Password?",
      ),
      content: Column(
        children: [
          TextFormField(
            controller: emailTextEditingController,
            decoration: InputDecoration(
              hintText: "Enter your Email",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
            onPressed: () {
              resetPassword();
              Navigator.pop(context);
            },
            child: Text("Reset Password"),
          )
        ],
      ),
    );
  }
}
