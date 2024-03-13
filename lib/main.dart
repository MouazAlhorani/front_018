import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mouaz_app_018/controllers/stlfunction.dart';
import 'package:mouaz_app_018/data/shared_pref_mz.dart';
import 'package:mouaz_app_018/data/theme_mz.dart';
import 'package:mouaz_app_018/views/homepage.dart';
import 'package:mouaz_app_018/views/login.dart';

main() {
  return runApp(const ProviderScope(child: MyAPP()));
}

class MyAPP extends StatelessWidget {
  const MyAPP({super.key});

  @override
  Widget build(BuildContext context) {
    bool autologin = false;
    return MaterialApp(
      initialRoute: '/',
      routes: {'': (context) => const HomePage()},
      debugShowCheckedModeBanner: false,
      themeMode: ThemeM.thememode,
      theme: ThemeM.lightTheme,
      home: FutureBuilder(future: Future(() async {
        if (await SharedPref.getloginfo() == null) {
          autologin = false;
        } else {
          var i = await SharedPref.getloginfo();
          autologin = await StlFunction.checklogin(
              ctx: Builder(builder: (BuildContext ctx) {
                return const SizedBox();
              }),
              username: i[0],
              password: i[1]);
        }
        return autologin;
      }), builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator.adaptive()));
        } else {
          return snap.data == true ? const HomePage() : const LogIN();
        }
      }),
    );
  }
}
