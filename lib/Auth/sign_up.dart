import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paytyme/Auth/login.dart';
import 'package:paytyme/resources/authentication.dart';
import 'package:path/path.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File _image;
  bool _isUploading = false;
  bool _isUploadCompleted = false;

  double _uploadProgress = 0;
  // firebase

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _usernameTextEditingController =
      TextEditingController();
  TextEditingController _passwordTextEditingController =
      TextEditingController();

  pickFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    cropImage(image);
  }

  pickFromPhone() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    cropImage(image);
  }
  cropImage(File image) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path, compressQuality: 40);

    setState(() {
      _image = croppedImage;
    });
  }

  selectImageAction(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            elevation: 11,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            title: Text("Pick Image From:", style: TextStyle()),
            children: [
              SimpleDialogOption(
                child: Text("Camera", style: TextStyle()),
                onPressed: () {
                  pickFromCamera();
                },
              ),
              SizedBox(height: 10),
              SimpleDialogOption(
                child: Text("Gallery", style: TextStyle()),
                onPressed: () {
                  pickFromPhone();
                },
              )
            ],
          );
        });
  }

  bool _isLoading = false;
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

   _showVerifyEmailSentDialog(context) {
    return showDialog(
      barrierDismissible: false,
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
                //_changeFormToLogin();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        );
      },
    );
  }

  uploadImage(context) async {
    if (_validateAndSave()) {
      try {
        if (_image != null) {
          setState(() {
            _isLoading = true;
            _isUploading = true;
            _uploadProgress = 0;
          });
          await authMethods.signUp(_emailTextEditingController.text,
              _passwordTextEditingController.text);
         

          FirebaseUser user = await _auth.currentUser();

          String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
              basename(_image.path);

          final StorageReference storageReference = _storage
              .ref()
              .child("profile_photos")
              .child(user.uid)
              .child(fileName);

          final StorageUploadTask uploadTask = storageReference.putFile(_image);

          final StreamSubscription<StorageTaskEvent> streamSubscription =
              uploadTask.events.listen((event) {
            var totalBytes = event.snapshot.totalByteCount;
            var transferred = event.snapshot.bytesTransferred;

            double progress = ((transferred * 100) / totalBytes) / 100;
            setState(() {
              _uploadProgress = progress;
            });
          });

          StorageTaskSnapshot onComplete = await uploadTask.onComplete;

          String photoUrl = await onComplete.ref.getDownloadURL();

          await authMethods.addDataToDb(
              currentUser: user,
              username: _usernameTextEditingController.text,
              password: _passwordTextEditingController.text,
              photoUrl: photoUrl);
          await authMethods.sendEmailVerification();
          _showVerifyEmailSentDialog(context);

          setState(() {
            _isLoading = false;
            _isUploading = false;
            _isUploadCompleted = true;
          });

          streamSubscription.cancel();
          Navigator.pop(this.context);
        } else {
          showDialog(
              context: this.context,
              builder: (ctx) {
                return AlertDialog(
                  content: Text("Please select image!"),
                  title: Text("Alert"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                );
              });
        }
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          _showCircularProgress(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () => selectImageAction(context),
                      child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Color(0xffFDCF09),
                          child: _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    _image,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    'assets/placeholder.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller:
                          _emailTextEditingController, // controller for email
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
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
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller:
                          _usernameTextEditingController, // controller for email
                      decoration: InputDecoration(
                        labelText: 'USERNAME',
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      validator: (value) {
                        return value.isEmpty ? 'Username is required.' : null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      obscureText: true,
                      controller:
                          _passwordTextEditingController, // controller for email
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      validator: (value) {
                        return value.isEmpty ? 'Password is required.' : null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(height: 10),
                    _isUploading
                        ? LinearProgressIndicator(
                            value: _uploadProgress,
                            backgroundColor: Colors.blue,
                          )
                        : Container(),
                    GestureDetector(
                      onTap: () {
                        uploadImage(context);
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
                              'SIGNUP',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )),
                          )),
                    ),
                  ],
                ),
              ),
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
