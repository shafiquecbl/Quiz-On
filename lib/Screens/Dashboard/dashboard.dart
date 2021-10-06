import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_on/Controller/page_controller.dart';
import 'package:quiz_on/Provider/provider.dart';
import 'package:quiz_on/Screens/Courses/courses.dart';
import 'package:quiz_on/Screens/Login/login.dart';
import 'package:quiz_on/Screens/Quizes/quizes.dart';
import 'package:quiz_on/Screens/Subjects/subjects.dart';
import 'package:quiz_on/constants.dart';
import 'package:quiz_on/size_config.dart';
import 'package:quiz_on/widget/Navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  MyPageController controller = MyPageController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<CustomProvier>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight! * .3,
                decoration: new BoxDecoration(
                  color: yellow,
                  borderRadius: BorderRadius.vertical(
                      bottom:
                          Radius.elliptical(SizeConfig.screenWidth!, 100.0)),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                          contentPadding:
                              EdgeInsets.only(left: 8, right: 8, top: 20),
                          leading: CircleAvatar(
                              radius: 30,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl: provider.loginResponse!.user!.image
                                      .toString(),
                                  placeholder: (context, string) {
                                    return Center(
                                        child: Icon(
                                      Icons.person,
                                    ));
                                  },
                                  errorWidget: (context, string, dynamic) {
                                    return Center(
                                        child: Icon(
                                      Icons.person,
                                    ));
                                  },
                                ),
                              )),
                          title: Text(
                            provider.loginResponse!.user!.name.toString(),
                            style: GoogleFonts.teko(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                          subtitle: Text(
                            provider.loginResponse!.user!.role.toString(),
                            style: GoogleFonts.teko(
                                color: whiteColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          ),
                          trailing: IconButton(
                            alignment: Alignment.topCenter,
                            icon: Icon(
                              Icons.logout,
                              color: whiteColor,
                            ),
                            onPressed: () {
                              logout();
                            },
                          )),
                      Consumer<CustomProvier>(
                        builder: (context, provider, child) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20, left: 15),
                            child: Row(
                              children: [
                                //////////////////////////////////////////

                                provider.currentPage !=
                                        0 // Show back button if user is not on courses page
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                            onTap: () {
                                              provider.currentPage == 1
                                                  ? controller.changePage(
                                                      context, 0)
                                                  : controller.changePage(
                                                      context, 1);
                                            },
                                            child: Icon(
                                              Icons.arrow_back_ios_new,
                                              color: black,
                                            )),
                                      )
                                    : Container(),

                                ////////////////////////////////////////

                                Text(
                                  provider.currentPage == 0
                                      ? courses
                                      : provider.currentPage == 1
                                          ? subjects
                                          : quizs,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: black),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      Expanded(
                          child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: MyPageController.controller,
                        children: [Courses(), Subjects(), Quizes()],
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref
        .remove('LoginResponse')
        .then((value) => pushAndRemoveUntil(context, Login()));
  }
}
