import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_on/Models/User.dart';
import 'package:quiz_on/Provider/provider.dart';
import 'package:quiz_on/Screens/Dashboard/Home.dart';
import 'package:quiz_on/Services/api_manager.dart';
import 'package:quiz_on/WIdgets/loading.dart';
import 'package:quiz_on/Widgets/Custom_Error.dart';
import 'package:quiz_on/constants.dart';
import 'package:quiz_on/size_config.dart';
import 'package:quiz_on/widget/Navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  //
  String? error;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider<CustomProvier>(
      create: (context) => CustomProvier(),
      child: Scaffold(
          body: ListView(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(19, 110, 0, 0),
                  child: Text('Hello',
                      style:
                          TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 185, 0, 0),
                  child: Text('There',
                      style: TextStyle(
                          fontSize: 80.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(270, 175, 0, 0),
                  child: Text('.',
                      style: TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          color: yellow)),
                )
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    emailField(),
                    SizedBox(height: 15),
                    passwordField(),
                    error != null
                        ? SizedBox(
                            height: 20,
                          )
                        : Container(),
                    error != null ? MyError(error: error) : Container(),
                    SizedBox(height: 40.0),
                    loginButton(),
                  ],
                ),
              )),
        ],
      )),
    );
  }

  emailField() {
    return TextFormField(
      controller: email,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter email';
        }

        return null;
      },
      decoration: InputDecoration(
          labelText: 'EMAIL',
          hintText: 'Enter your email',
          labelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: yellow))),
    );
  }

  passwordField() {
    return TextFormField(
      controller: password,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        }

        return null;
      },
      decoration: InputDecoration(
          labelText: 'PASSWORD',
          hintText: 'Enter your password',
          labelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: yellow))),
      obscureText: true,
    );
  }

  loginButton() {
    setState(() {
      error = null;
    });
    return Container(
      height: 45,
      width: SizeConfig.screenWidth! / 1.2,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              primary: yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              )),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              login();
            }
          },
          icon: Icon(Icons.login),
          label: Text(
            'LOGIN',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  login() {
    showLoadingDialog(context);
    APIManager()
        .studentLogin(email.text.trimRight(), password.text)
        .then((value) async {
      moveNext(loginResponse: value);
    }).catchError((e) {
      Navigator.pop(context);
      setState(() {
        error = 'Invalid Credentials';
      });
    });
  }

  moveNext({@required StudentLoginResponse? loginResponse}) async {
    CustomProvier provider = Provider.of(context, listen: false);
    provider.saveLoginResponse(studentLoginResponse: loginResponse);
    SharedPreferences pref = await SharedPreferences.getInstance();
    Navigator.pop(context);
    if (loginResponse!.user!.suspend == true) {
      pref.remove('LoginResponse');
      setState(() {
        error = 'User Suspended';
      });
    } else {
      CustomProvier provider = Provider.of(context, listen: false);
      provider.changeCurrentPage(index: 0);
      pushAndRemoveUntil(context, Home());
    }
  }
}
