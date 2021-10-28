import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quiz_on/Models/Student/Quiz.dart';
import 'package:quiz_on/Models/Student/solved_quiz.dart';
import 'package:quiz_on/Models/Student/student_solved_quiz.dart';
import 'package:quiz_on/constants.dart';

import 'components/option.dart';

class QuizDetails extends StatefulWidget {
  final SolvedQuiz? solvedQuiz;
  final Quizz? quiz;
  const QuizDetails({@required this.solvedQuiz, @required this.quiz});

  @override
  _QuizDetailsState createState() => _QuizDetailsState();
}

class _QuizDetailsState extends State<QuizDetails> {
  ScrollController controller = ScrollController();
  double? percentage;
  Future<Quiz1>? quizModel;

  double calculatePercentage(
      {@required int? totalQuestions, @required int? marks}) {
    return percentage = (marks! / totalQuestions!) * 100;
  }

  @override
  Widget build(BuildContext context) {
    percentage = calculatePercentage(
        marks: widget.solvedQuiz!.marks,
        totalQuestions: widget.quiz!.question!.length);
    return Scaffold(
        appBar: AppBar(
          title: Text('Quiz Details'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                scoreDetails(quiz: widget.quiz),
                Divider(),
                percentageWidget(),
                Divider(),
                for (int index = 0;
                    index <= widget.quiz!.question!.length - 1;
                    index++)
                  questionData(
                      question: widget.quiz!.question![index],
                      submittedAnswer:
                          widget.solvedQuiz!.submittedAnswer![index]),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ));
  }

  scoreDetails({@required Quizz? quiz}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Total Questions
        Expanded(
          child: Column(
            children: [
              Text(
                "Total Questions",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                quiz!.question!.length.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),

        // Attempted Questions
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "Attempted Questions",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                widget.solvedQuiz!.questionAttempted.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }

  percentageWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Marks Obtained
        Expanded(
          child: Column(
            children: [
              Text(
                "Marks Obtained",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                widget.solvedQuiz!.marks.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Percentage",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 7,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: CircularPercentIndicator(
                  radius: 50.0,
                  lineWidth: 2.0,
                  percent: percentage! / 100,
                  center: Text(
                    '${percentage!.toStringAsFixed(0)}%',
                  ),
                  progressColor: percentage! <= 50.0
                      ? Colors.red
                      : 51.0 <= percentage! && percentage! <= 70.0
                          ? Colors.orange
                          : Colors.green,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  questionData(
      {@required Question1? question,
      @required SubmittedAnswer? submittedAnswer}) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.05,
          decoration: BoxDecoration(
            color: yellow,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              question!.questionStatement.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        question.questionImage!.length != 0
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 2.0,
                      height: 450,
                      enableInfiniteScroll: false,
                    ),
                    items: question.questionImage!.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: CachedNetworkImage(
                              imageUrl: i,
                              placeholder: (context, string) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorWidget: (context, string, dynamic) {
                                return Icon(Icons.image);
                              },
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              )
            : Container(),

        //////////////////////////////////////////////////////

        submittedAnswer!.answer != question.answer
            ? OptionWidgett(
                text: submittedAnswer.answer.toString(),
                isTrue: false,
              )
            : Container(),

        submittedAnswer.answer != question.answer
            ? SizedBox(
                height: 10,
              )
            : Container(),

        OptionWidgett(
          text: question.answer.toString(),
          isTrue: true,
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 0.8,
            color: Colors.grey[300])
      ],
    );
  }
}
