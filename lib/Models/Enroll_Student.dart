import 'package:quiz_on/Models/Courses.dart';
import 'package:quiz_on/Models/Student.dart';

class EnrollStudent {
  EnrollStudent({
    this.id,
    this.course,
    this.student,
  });

  String? id;
  Course? course;
  Student? student;

  factory EnrollStudent.fromJson(Map<String, dynamic> json) => EnrollStudent(
        id: json['_id'],
        course: Course.fromJson(json['course']),
        student: Student.fromJson(json['student'][0]),
      );
}

class AddEnrollStudent {
  AddEnrollStudent({this.studentId, this.courseId});
  String? courseId, studentId;

  Map<String, dynamic> toJson() => {
        "course": courseId,
        "student": studentId,
      };
}
