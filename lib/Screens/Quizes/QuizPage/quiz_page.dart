import 'dart:async';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:provider/provider.dart';
import 'package:quiz_on/Models/Student/Quiz.dart';
import 'package:quiz_on/Provider/provider.dart';
import 'package:quiz_on/Services/api_manager.dart';
import 'package:quiz_on/constants.dart';

import 'components/option.dart';

class QuizPage extends StatefulWidget {
  final Quiz1? quiz;
  const QuizPage({@required this.quiz});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  ScrollController controller = ScrollController();
  CustomProvier? provide;

  bool? option1 = false;
  bool? option2 = false;
  bool? option3 = false;
  bool? option4 = false;
  bool? isSelected = false;

  int activeStep = 0;

  Question1? currentQuestion;
  String? correctAnswer;

  @override
  void initState() {
    getRemainingTime();
    super.initState();
  }

  getRemainingTime() {
    CustomProvier? provider =
        Provider.of<CustomProvier>(context, listen: false);
    provider.remainingTime = widget.quiz!.time;
    Timer.periodic(Duration(seconds: 1), (t) {
      handleTime(provider: provider);
    });
  }

  handleTime({@required CustomProvier? provider}) {
    if (provider!.remainingTime == 0 &&
        activeStep > widget.quiz!.question!.length - 1) {
      submitEmptyQuestion();

      // If last question and timer runs out then end the quiz
      if (activeStep == widget.quiz!.question!.length - 1) {
        print('Do Nothing');
      }
      // if it's not last question and timer runs out then move to next question
      else {
        setState(() {
          activeStep = activeStep + 1;
          isSelected = false;
        });
      }

      provider.remainingTime = widget.quiz!.time;
    }
    updateRemainingTime();
  }

  submitEmptyQuestion() {
    CustomProvier? provider =
        Provider.of<CustomProvier>(context, listen: false);
    return APIManager().submitQuestion(context, provider.loginResponse!,
        token: provider.loginResponse!.token,
        quizId: widget.quiz!.id,
        questionId: currentQuestion!.id,
        correctAnswer: '');
  }

  updateRemainingTime() {
    CustomProvier? provider =
        Provider.of<CustomProvier>(context, listen: false);
    provider.updateRemainingTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Consumer<CustomProvier>(
          builder: (context, provider, child) {
            provide = provider;
            return Text(
                'TIME LEFT: ${formatedTime(provider.getRemainingTime()!)}');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 9, right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NumberStepper(
              enableNextPreviousButtons: false,
              numbers: List.generate(
                  widget.quiz!.question!.length, (index) => index + 1),
              activeStep: activeStep,
              onStepReached: (index) {
                setState(() {
                  activeStep = index;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            quizBody(
              question: widget.quiz!.question![activeStep],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                // activeStep == 0
                //     ? Container()
                //     : widget.quiz!.bound == 'perQuestion'
                //         ? Container()
                //         : previousButton(),
                getButton()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getButton() {
    return activeStep == widget.quiz!.question!.length - 1 && isSelected == true
        ? submitButton()
        : isSelected == true
            ? nextButton()
            : Container();
  }

  Widget nextButton() {
    return Container(
      width: 100,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          // Increment activeStep, when the next button is tapped. However, check for upper bound.
          if (activeStep < widget.quiz!.question!.length - 1) {
            print(widget.quiz!.id);
            submitQuestion();
            setState(() {
              activeStep++; //move to next question

              CustomProvier? provider =
                  Provider.of<CustomProvier>(context, listen: false);
              provider.remainingTime =
                  widget.quiz!.time; //update Time when new question started

              option1 = false;
              option2 = false;
              option3 = false;
              option4 = false;
              isSelected = false;
            });
          }
        },
        child: Text('Next'),
      ),
    );
  }

  Widget submitButton() {
    return Container(
      width: 100,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          super.dispose();

          ///submit whole quiz
          APIManager().submitLastQuestion(context, provide!.loginResponse!,
              token: provide!.loginResponse!.token,
              quizId: widget.quiz!.id,
              questionId: currentQuestion!.id,
              correctAnswer: correctAnswer);
        },
        child: Text('SUBMIT'),
      ),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return Container(
      width: 100,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
          if (activeStep > 0) {
            setState(() {
              activeStep--;
            });
          }
        },
        child: Text('Back'),
      ),
    );
  }

  String formatedTime(int secTime) {
    String getParsedTime(String time) {
      if (time.length <= 1) return "0$time";
      return time;
    }

    int min = secTime ~/ 60;
    int sec = secTime % 60;

    String parsedTime =
        getParsedTime(min.toString()) + " : " + getParsedTime(sec.toString());

    return parsedTime;
  }

  submitQuestion() {
    APIManager().submitQuestion(context, provide!.loginResponse!,
        token: provide!.loginResponse!.token,
        quizId: widget.quiz!.id,
        questionId: currentQuestion!.id,
        correctAnswer: correctAnswer);
  }

  /////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////

  quizBody({@required Question1? question}) {
    currentQuestion = question;
    return Expanded(
        child: Scrollbar(
      isAlwaysShown: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            header(question: question),

            //////////////////////////////////////////////////////

            SizedBox(
              height: 10,
            ),

            //////////////////////////////////////////////////////

            OptionWidget(
                text: question!.options![0].options1,
                index: 1,
                onPressed: () {
                  setState(() {
                    option1 = true;
                    option2 = false;
                    option3 = false;
                    option4 = false;
                    isSelected = true;
                    correctAnswer = question.options![0].options1;
                  });
                },
                isSelected: option1),
            OptionWidget(
                text: question.options![0].options2,
                index: 2,
                onPressed: () {
                  setState(() {
                    option1 = false;
                    option2 = true;
                    option3 = false;
                    option4 = false;
                    isSelected = true;
                    correctAnswer = question.options![0].options2;
                  });
                },
                isSelected: option2),
            OptionWidget(
                text: question.options![0].options3,
                index: 3,
                onPressed: () {
                  setState(() {
                    option1 = false;
                    option2 = false;
                    option3 = true;
                    option4 = false;
                    isSelected = true;
                    correctAnswer = question.options![0].options3;
                  });
                },
                isSelected: option3),
            OptionWidget(
                text: question.options![0].options4,
                index: 4,
                onPressed: () {
                  setState(() {
                    option1 = false;
                    option2 = false;
                    option3 = false;
                    option4 = true;
                    isSelected = true;
                    correctAnswer = question.options![0].options4;
                  });
                },
                isSelected: option4)
          ],
        ),
      ),
    ));
  }

  /// Returns the header wrapping the header text.
  Widget header({@required Question1? question}) {
    return Container(
      width: MediaQuery.of(context).size.width,
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
    );
  }
}
