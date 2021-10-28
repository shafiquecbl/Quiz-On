import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quiz_on/Controller/page_controller.dart';
import 'package:quiz_on/Models/Student/Quiz.dart';
import 'package:quiz_on/Models/Student/solved_quiz.dart';
import 'package:quiz_on/Models/Student/student_solved_quiz.dart';
import 'package:quiz_on/Provider/provider.dart';
import 'package:quiz_on/Screens/Login/login.dart';
import 'package:quiz_on/Screens/Score%20Board/quiz_details.dart';
import 'package:quiz_on/Services/api_manager.dart';
import 'package:quiz_on/WIdgets/network_error.dart';
import 'package:quiz_on/Widgets/custom_card.dart';
import 'package:quiz_on/Widgets/loading.dart';
import 'package:quiz_on/constants.dart';
import 'package:quiz_on/size_config.dart';
import 'package:quiz_on/widget/Navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreBoard extends StatefulWidget {
  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  MyPageController controller = MyPageController();
  Future<List<StudentQuiz>>? studentQuiz;

  @override
  void initState() {
    getStudentQuiz();
    super.initState();
  }

  getStudentQuiz() {
    CustomProvier provider = Provider.of<CustomProvier>(context, listen: false);
    studentQuiz = APIManager().getStudentScore(
        token: provider.loginResponse!.token,
        id: provider.loginResponse!.user!.id);
  }

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
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 15),
                        child: Row(
                          children: [
                            Text(
                              'My Quizes',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: black),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<StudentQuiz>>(
                          future: studentQuiz,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<StudentQuiz>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) return MyLoading();

                            //if data is null show network error
                            if (snapshot.data == null)
                              return NetworkError(onPressed: () {
                                setState(() {
                                  studentQuiz = APIManager().getStudentScore(
                                      token: provider.loginResponse!.token,
                                      id: provider.loginResponse!.user!.id);
                                });
                              });

                            //if data length is ZERO show message
                            if (snapshot.data!.length == 0)
                              return Center(
                                child: Text('No Quiz Available'),
                              );

                            return quizList(sQuiz: snapshot.data);
                          },
                        ),
                      ),
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

  quizList({@required List<StudentQuiz>? sQuiz}) {
    return GridView.builder(
        itemCount: sQuiz!.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 3 / 2.3,
            crossAxisSpacing: 25,
            mainAxisSpacing: 25),
        itemBuilder: (context, index) {
          return quiz(quiz: sQuiz[index], index: index);
        });
  }

  quiz({@required StudentQuiz? quiz, @required int? index}) {
    return CourseCard(
      text: quiz!.quiz!.quizName,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    QuizDetails(solvedQuiz: quiz.solvedQuiz, quiz: quiz.quiz)));
      },
      icon: Icons.library_books_outlined,
    );
  }

  logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref
        .remove('LoginResponse')
        .then((value) => pushAndRemoveUntil(context, Login()));
  }
}
