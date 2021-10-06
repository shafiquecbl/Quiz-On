import 'package:flutter/widgets.dart';
import 'package:quiz_on/Models/Student/solved_quiz.dart';
import 'package:quiz_on/Models/Student/student_courses.dart';
import 'package:quiz_on/Models/Student/student_subjects.dart';
import 'package:quiz_on/Models/User.dart';

class CustomProvier extends ChangeNotifier {
  StudentLoginResponse? loginResponse;

  StudentCourse? course;
  StudentSubject? subject;

  int? remainingTime;
  int? getRemainingTime() => remainingTime;

  SolvedQuiz? solvedQuiz;
  String? studentId;

  int currentPage = 0;

  /////////////////////////////////////////////////////////////////////////

  saveLoginResponse({@required StudentLoginResponse? studentLoginResponse}) {
    loginResponse = studentLoginResponse;
    notifyListeners();
  }

  changeCurrentPage({@required int? index}) {
    currentPage = index!;
    notifyListeners();
  }

  saveStudentCourse({@required StudentCourse? studentCourse}) {
    course = studentCourse;
    notifyListeners();
  }

  saveStudentSubject({@required StudentSubject? studentSubject}) {
    subject = studentSubject;
    notifyListeners();
  }

  updateRemainingTime() {
    if (remainingTime! > 0) {
      remainingTime = remainingTime! - 1;
    }
    notifyListeners();
  }

  saveSolvedQuiz({@required SolvedQuiz? quiz}) {
    solvedQuiz = quiz;
    notifyListeners();
  }

  saveStudentId({@required String? id}) {
    studentId = id;
    notifyListeners();
  }
}
