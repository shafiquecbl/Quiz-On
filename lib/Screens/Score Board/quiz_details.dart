import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quiz_on/Models/Student/Quiz.dart';
import 'package:quiz_on/Models/Student/solved_quiz.dart';
import 'package:quiz_on/constants.dart';

class QuizDetails extends StatefulWidget {
  final SolvedQuiz? solvedQuiz;
  final Quiz1? quiz;
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
          child: Column(
            children: [
              scoreDetails(quiz: widget.quiz),
              Divider(),
              percentageWidget(),
              Divider(),
              Expanded(
                  flex: 4,
                  child: Scrollbar(
                    showTrackOnHover: true,
                    isAlwaysShown: true,
                    interactive: true,
                    controller: controller,
                    child: ListView.separated(
                        controller: controller,
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                        itemCount: widget.quiz!.question!.length,
                        itemBuilder: (context, index) {
                          Question1 question = widget.quiz!.question![index];
                          return questionData(question: question);
                        }),
                  )),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ));
  }

  scoreDetails({@required Quiz1? quiz}) {
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

  questionData({@required Question1? question}) {
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
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            width: MediaQuery.of(context).size.width / 1.15,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              leading: Text(
                'Answer.',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600),
              ),
              title: Text(
                question.answer.toString(),
                style: TextStyle(fontSize: 16),
              ),
            )),
      ],
    );
  }
}
