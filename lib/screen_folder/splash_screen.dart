import 'package:flutter/material.dart';


import 'package:splash_screen_view/SplashScreenView.dart';
import '../file_constant/constant.dart';

import 'package:get/get.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _prefs;
class ScreenSplash extends StatefulWidget {
  @override
  _ScreenSplashState createState() => _ScreenSplashState();
}
class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    super.initState();
    getfilepath();


  }
  getfilepath() async{
    _prefs = await SharedPreferences.getInstance();
    print(_prefs.getString('filepath'));
    if(_prefs.getString("filepath")==null){
      Future.delayed(const Duration(milliseconds: 500), (){Get.offNamed('home');});}
    else{
      Future.delayed(const Duration(milliseconds: 500),(){  Get.offNamed('second', arguments: '${_prefs.getString("filepath")}');});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height:MediaQuery.of(context).size.height,
      width:MediaQuery.of(context).size.width,
      color:  Color(0xFF4E4AC2),
      child:Image.asset('assets/image/jensenpdfviewerlogo.jpg'),
    );
  }
}
