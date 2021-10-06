import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_on/Models/User.dart';
import 'package:quiz_on/Screens/Dashboard/Home.dart';
import 'package:quiz_on/Screens/Login/login.dart';
import 'package:quiz_on/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Provider/provider.dart';
import 'WIdgets/loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CustomProvier>(
      create: (context) => CustomProvier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QuizOn',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                elevation: 0,
                backgroundColor: whiteColor,
                iconTheme: IconThemeData(color: Colors.black87)),
            scaffoldBackgroundColor: whiteColor,
            primaryColor: yellow,
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
        home: FutureBuilder<StudentLoginResponse>(
          future: getResponse(),
          builder: (BuildContext context,
              AsyncSnapshot<StudentLoginResponse> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return MyLoading();
            CustomProvier provider =
                Provider.of<CustomProvier>(context, listen: false);
            provider.saveLoginResponse(studentLoginResponse: snapshot.data);
            return provider.loginResponse != null ? Home() : Login();
          },
        ),
      ),
    );
  }

  Future<StudentLoginResponse> getResponse() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userPref = pref.getString('LoginResponse').toString();
    // ignore: unnecessary_null_comparison
    var jsonMap = json.decode(userPref);
    return StudentLoginResponse.fromJson(jsonMap);
  }
}
