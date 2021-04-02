import 'package:carousel_pro/carousel_pro.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:paytyme/models/user.dart';
import 'package:paytyme/pages/browser.dart';
import 'package:paytyme/provider/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;

  UserProvider userProvider;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();
    });
    super.initState();
    //get current user information from database
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    UserData user = userProvider.getUser;
    print(_currentPage);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset('assets/icon.png'),
              ),
            ),
            Container(
                child: RaisedButton(
              onPressed: () {
                Flushbar(
                  backgroundColor: Colors.orange,
                  title: "More Info About  PAYTYME",
                  message:
                      "paytyme is a weel-designed, feature-compelete app offering online bills payment, its especially aatractive for Android and IOS users. With our fingerprint encryption, it make your wallet have a closed security protocol. The paytme outstanding feature allows users to fund thier wallet wthout hassle. ",
                  duration: Duration(seconds: 10),
                )..show(context);
              },
              child: Text(
                'ABOUT US',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
              color: Colors.white,
            ))
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Container(
              margin: EdgeInsets.all(10.0),
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width,
              child: Carousel(
                  dotColor: Colors.blue,
                  boxFit: BoxFit.cover,
                  images: [
                    Image.asset('assets/images21.jpg'),
                    Image.asset('assets/images12.jpg'),
                    Image.asset('assets/images15.jpg'),
                    Image.asset('assets/images14.jpg'),
                    Image.asset('assets/images11.jpg'),
                  ],
                  autoplay: true,
                  indicatorBgPadding: 5.0,
                  dotPosition: DotPosition.bottomCenter,
                  animationCurve: Curves.fastOutSlowIn,
                  animationDuration: Duration(seconds: 1)),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          (user.photoUrl == null)
              ? CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xffFDCF09),
                )
              : CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xffFDCF09),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Image.network(user.photoUrl))),
          SizedBox(height: 10),
          Container(
            child: Center(
              child: Text(
                (user.username == null) ? "Loading..." :"Username: "+ user.username,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Container(
          //   child: TextFormField(
          //     keyboardType: TextInputType.name,
          //     decoration: InputDecoration(
          //       labelText: 'USERNAME',
          //       labelStyle: TextStyle(
          //         fontFamily: 'Montserrat',
          //         fontWeight: FontWeight.bold,
          //         color: Colors.grey,
          //       ),
          //       focusedBorder: UnderlineInputBorder(
          //         borderSide: BorderSide(color: Colors.orange),
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Container(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'PAY YOUR BILLS ',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 26.0),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      'WITH EASE USING',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 26.0),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      'PAYTYME',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 26.0),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      'Your VTU, GOTV,DSTV And Data Subcription ',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      'Her At Your Finger Tip+EDUCATION ',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Container(
              margin: EdgeInsets.all(10.0),
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width,
              child: Carousel(
                  dotColor: Colors.blue,
                  boxFit: BoxFit.cover,
                  images: [
                    Image.asset('assets/images21.jpg'),
                    Image.asset('assets/images22.jpg'),
                    Image.asset('assets/images25.jpg'),
                    Image.asset('assets/images24.jpg'),
                    Image.asset('assets/images23.jpg'),
                  ],
                  autoplay: true,
                  indicatorBgPadding: 5.0,
                  dotPosition: DotPosition.bottomCenter,
                  animationCurve: Curves.fastOutSlowIn,
                  animationDuration: Duration(seconds: 1)),
            ),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.orange, style: BorderStyle.solid, width: 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BrowserView(
                                    url:
                                        'https://www.paytyme.com.ng/?dashboard',
                                  )));
                    },
                    child: Text(
                      'Account',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    color: Colors.white,
                  ),
                ),
                Container( 
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BrowserView( 
                                    url:
                                        'https://www.paytyme.com.ng/?dashboard&jump=all%20services&filter=',
                                  )));
                      // const url =
                      //     'https://www.paytyme.com.ng/?dashboard&jump=all%20services&filter=';
                      // launchURL(url);
                    },
                    child: Text(
                      'Recharge',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    color: Colors.white,
                  ),
                ),
                // Container(
                //   alignment: Alignment.center,
                //   child: RaisedButton(
                //     splashColor: Colors.white,
                //     onPressed: () {},
                //     child: Text(
                //       'Recipt',
                //       style: TextStyle(
                //           fontFamily: 'Montserrat',
                //           color: Colors.black,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 20.0),
                //     ),
                //     color: Colors.white,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
