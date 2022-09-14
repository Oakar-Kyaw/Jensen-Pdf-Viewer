import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../get/controller.dart';

bool isloading = false;

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key key}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    return GetBuilder<Controller>(builder: (detailscreen) {
      return SafeArea(
          child: Scaffold(
              body: Stack(children: [
        Container(
          color: Color(0xFF8D7956),
          margin: EdgeInsets.all(5),
          child: WebView(
            initialUrl: '${Get.arguments}',
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (value) {
              setState(() {
                isloading = true;
              });
            },
            onPageFinished: (value) {
              setState(() {
                isloading = false;
              });
            },
          ),
        ),
        isloading
            ? Container(
                child: Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    CircularProgressIndicator(),
                  ]),
                ),
              )
            : Stack()
      ])));
    });
  }
}
