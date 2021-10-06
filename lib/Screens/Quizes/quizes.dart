import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_on/Controller/page_controller.dart';
import 'package:quiz_on/Models/Student/Quiz.dart';
import 'package:quiz_on/Provider/provider.dart';
import 'package:quiz_on/Services/api_manager.dart';
import 'package:quiz_on/WIdgets/loading.dart';
import 'package:quiz_on/Widgets/custom_card.dart';

import 'QuizPage/quiz_page.dart';

class Quizes extends StatefulWidget {
  @override
  _QuizesState createState() => _QuizesState();
}

class _QuizesState extends State<Quizes> {
  MyPageController controller = MyPageController();
  late List<Quiz1> subjectQuiz;
  List<Quiz1> quizList = [];
  List<String> idList = [];
  bool isLoaded = false;
  bool isEmpty = false;

  @override
  void initState() {
    getStudentQuiz();
    super.initState();
  }

  getStudentQuiz() {
    CustomProvier provider = Provider.of<CustomProvier>(context, listen: false);
    APIManager()
        .getStudentQuiz(
            token: provider.loginResponse!.token,
            id: provider.loginResponse!.user!.id)
        .then((value) {
      for (var quiz in value) {
        idList.add(quiz.quizName!);
      }
      getSubjectQuiz();
    });
  }

  getSubjectQuiz() {
    CustomProvier provider = Provider.of<CustomProvier>(context, listen: false);
    APIManager()
        .getSubjectQuizs(
            token: provider.loginResponse!.token, id: provider.subject!.id)
        .then((value) {
      subjectQuiz = value;
      if (value.isNotEmpty) {
        filterList();
      } else {
        setState(() {
          isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomProvier>(
      builder: (context, provider, child) {
        return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: isLoaded == false
                ? MyLoading()
                : quizList.isEmpty || subjectQuiz.isEmpty
                    ? Center(
                        child: Text('No quiz available right now!'),
                      )
                    : GridView.builder(
                        itemCount: quizList.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            childAspectRatio: 3 / 2.3,
                            crossAxisSpacing: 25,
                            mainAxisSpacing: 25),
                        itemBuilder: (context, index) {
                          Quiz1 quiz = quizList[index];
                          return CourseCard(
                            text: quiz.quizName,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => QuizPage(
                                            quiz: quiz,
                                          )));
                            },
                            icon: Icons.library_books_outlined,
                          );
                        }));
      },
    );
  }

  filterList() {
    subjectQuiz.forEach((quiz) {
      print('1: ${quiz.id}');
      if (idList.contains(quiz.id) == true) {
        setState(() {
          isLoaded = true;
        });
      } else {
        setState(() {
          isLoaded = true;
          quizList.add(quiz);
        });
      }
    });
  }
}
