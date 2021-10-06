import 'package:flutter/material.dart';
import 'package:quiz_on/Screens/Dashboard/dashboard.dart';
import 'package:quiz_on/constants.dart';
import 'package:quiz_on/widget/Navigator.dart';

class QuizCompleted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(color: Colors.white, fontSize: 22);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            direction: Axis.vertical,
            children: [
              Image.asset(
                'assets/done.png',
                width: size.width / 1,
                height: size.height / 2.5,
              ),
              Text(
                'Quiz Completed!',
                style: TextStyle(fontSize: 26),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: 140,
                height: 50,
                child: TextButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: yellow,
                      elevation: 0,
                    ),
                    onPressed: () async {
                      pushAndRemoveUntil(context, Dashboard());
                    },
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    label: Text('Home', style: style)),
              ),
            ]),
      ),
    );
  }
}
