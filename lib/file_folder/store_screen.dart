import 'package:shared_preferences/shared_preferences.dart';

String filespath;
SharedPreferences _prefs;
save(String filepathname) async {
  _prefs = await SharedPreferences.getInstance();
  _prefs.setString("filepath", filepathname);
}


savePageNo(int pageno) async{
  _prefs = await SharedPreferences.getInstance();
  _prefs.setInt("pageno", pageno);
}