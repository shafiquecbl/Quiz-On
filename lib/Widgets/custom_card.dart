import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_on/constants.dart';

class CourseCard extends StatefulWidget {
  final Function()? onPressed;
  final String? text;
  final IconData? icon;
  const CourseCard(
      {@required this.text, @required this.onPressed, @required this.icon});

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 3, left: 3),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: yellow,
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(1, 0),
          )
        ], color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
        child: TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateColor.resolveWith(
                (states) => yellow.withOpacity(0.7)),
          ),
          onPressed: widget.onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                widget.icon,
                color: Colors.black,
                size: 42,
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                widget.text.toString(),
                style: GoogleFonts.teko(
                    fontSize: 18, fontWeight: FontWeight.w600, color: black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
