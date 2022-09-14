import 'package:flutter/material.dart';

import '../file_constant/constant.dart';


class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          child: Text('Credits', style: fontStyle),
        ),
        SizedBox(
          height: 20,
        ),
        Container(child: Container(margin: EdgeInsets.only(left: 20, right: 5), child: Text('Special thanks to which helped make this application finished ', style: styles))),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Text('To Report Bugs And Error', style: fontStyle),
        ),
        SizedBox(
          height: 20,
        ),
        Container(child: Container(margin: EdgeInsets.only(left: 20, right: 5), child: Text('If you encounter bugs or errors or other concerns, send an email to < jensenpdfviewer@gmail.com > ', style: styles))),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Text('Developer', style: fontStyle),
        ),
        SizedBox(
          height: 20,
        ),
        Container(width: MediaQuery.of(context).size.width, margin: EdgeInsets.only(left: 20, right: 5), child: Text("Developed by Alex Jensen(Oakar Kyaw) ", style: styles)),
      ],
    ))));
  }
}
