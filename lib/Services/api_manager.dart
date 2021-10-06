import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_on/Models/Admin_Login.dart';
import 'package:quiz_on/Models/Student/Quiz.dart';
import 'package:quiz_on/Models/Student/solved_quiz.dart';
import 'package:quiz_on/Models/Student/student_courses.dart';
import 'package:quiz_on/Models/Student/student_subjects.dart';
import 'package:quiz_on/Models/Student/submit_quiz.dart';
import 'package:quiz_on/Models/User.dart';
import 'package:quiz_on/Screens/Quizes/QuizPage/components/quiz_completed.dart';
import 'package:quiz_on/widget/Navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIManager {
  var client = http.Client();
  var loginResponse;
  String baseUrl = 'http://192.168.100.84:4000';
  Dio dio = Dio();

  ///////////////////////////////////////////////////////////

  Future<StudentLoginResponse> studentLogin(email, password) async {
    print('Reached');
    return await client
        .post(Uri.parse('$baseUrl/admin/auth/login'),
            body: Login(email: email, password: password).toJson())
        .then((response) async {
      print(response.body);
      var jsonMap = json.decode(response.body);
      StudentLoginResponse loginResponse =
          StudentLoginResponse.fromJson(jsonMap);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('LoginResponse', jsonEncode(jsonMap));
      return loginResponse;
    });
  }

  Future<List<StudentCourse>> getStudentCourses(
      {@required token, @required String? id}) async {
    return await client.get(
        Uri.parse('$baseUrl/api/enrollStudent/getCourseByStdId/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      List<StudentCourse> jsonMap = (json.decode(response.body) as List)
          .map((e) => StudentCourse.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  Future<List<StudentSubject>> getStudentSubjects(
      {@required token, @required String? id}) async {
    return await client.get(
        Uri.parse('$baseUrl/api/enrollStudent/getSubjectsByCourseId/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      List<StudentSubject> jsonMap = (json.decode(response.body) as List)
          .map((e) => StudentSubject.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  Future<List<Quiz1>> getSubjectQuizs(
      {@required token, @required String? id}) async {
    return await client.get(Uri.parse('$baseUrl/api/student/$id/quizname'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      print('RESPONSEEEE: ${response.body}');
      List<Quiz1> jsonMap = (json.decode(response.body) as List)
          .map((e) => Quiz1.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  submitQuestion(BuildContext context, StudentLoginResponse loginResponse,
      {@required token,
      @required String? quizId,
      @required String? questionId,
      @required String? correctAnswer}) async {
    return await dio
        .post('$baseUrl/api/solvedQuizData/addSolvedQuizData',
            data: SubmitQuiz(
                    quizId: quizId,
                    questionId: questionId,
                    correctAnswer: correctAnswer)
                .toJson(),
            options: Options(headers: {
              'Authorization': 'Bearer $token',
            }))
        .then((value) => print(value.data));
  }

  submitLastQuestion(BuildContext context, StudentLoginResponse loginResponse,
      {@required token,
      @required String? quizId,
      @required String? questionId,
      @required String? correctAnswer}) async {
    print('REACHED');
    return await dio
        .post('$baseUrl/api/solvedQuizData/addSolvedQuizData',
            data: SubmitQuiz(
                    quizId: quizId,
                    questionId: questionId,
                    correctAnswer: correctAnswer)
                .toJson(),
            options: Options(headers: {
              'Authorization': 'Bearer $token',
              "Content-Type": "application/json"
            }))
        .then((value) {
      pushAndRemoveUntil(context, QuizCompleted());
    });
  }

  Future<List<SolvedQuiz>> getStudentQuiz(
      {@required token, @required String? id}) async {
    return await client.get(
        Uri.parse('$baseUrl/api/solvedQuizData/getQuizStudent/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        }).then((response) async {
      List<SolvedQuiz> jsonMap = (json.decode(response.body) as List)
          .map((e) => SolvedQuiz.fromJson(e))
          .toList();
      return jsonMap;
    });
  }

  Future<Quiz1> getQuizById({@required token, @required String? id}) async {
    return await client.get(Uri.parse('$baseUrl/admin/quiz/getQuiz/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        }).then((response) async {
      var jsonMap = json.decode(response.body);
      Quiz1 quiz = Quiz1.fromJson(jsonMap);
      return quiz;
    });
  }
}
