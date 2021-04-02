import 'package:flutter/material.dart';
import 'package:paytyme/pages/auth_screen.dart';
import 'package:paytyme/provider/user_provider.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // wrapping the main widget with provider for state management
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()), 
      ],
          child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        // goes to splash screen first to determine authentication status
        home: AuthScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
