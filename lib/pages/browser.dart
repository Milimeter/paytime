import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserView extends StatefulWidget {
  final String url;
  BrowserView({this.url});
  @override
  _BrowserViewState createState() => _BrowserViewState();
}

class _BrowserViewState extends State<BrowserView> {
  WebViewController _webViewController;
  bool showLoading = false;

  void updateLoading(bool ls) {
    this.setState(() {
      showLoading = ls;
    });
  }

  showLoadingBar() {
    if (_webViewController != null) {
      updateLoading(true);
      _webViewController.loadUrl(widget.url).then((onValue) {}).catchError((e) {
        updateLoading(false);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    showLoadingBar();
  }

  @override
  Widget build(BuildContext context) {
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
                      "paytymr is a weel-designed, feature-compelete app offering online bills payment, its especially aatractive for Android and IOS users. With our fingerprint encryption, it make your wallet have a closed security protocol. The paytme outstanding feature allows users to fund thier wallet wthout hassle. ",
                  duration: Duration(seconds: 10),
                )..show(context);
              },
              child: Text(
                'ABOUT US',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
              color: Colors.white,
            ))
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: widget.url,
            onPageFinished: (data) {
              updateLoading(false);
            },
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (webViewController) {
              _webViewController = webViewController;
            },
          ),
          (showLoading)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center()
        ],
      ),
    );
  }
}
