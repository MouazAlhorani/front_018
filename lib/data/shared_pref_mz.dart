import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static setloginfo({required List<String> logininfolist}) async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    await sharedpref.setStringList('logininfo', logininfolist);
  }

  static getloginfo() async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    return sharedpref.getStringList('logininfo');
  }

  static removeloginfo() async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    return sharedpref.remove('logininfo');
  }
}
