import 'package:quiz_on/Models/Courses.dart';
import 'package:quiz_on/Models/Subjects.dart';
import 'package:quiz_on/Models/Teachers.dart';

class TeacherSubject {
  TeacherSubject({this.id, this.course, this.teacher, this.subject});

  String? id, name;
  Course? course;
  Teacher? teacher;
  Subject? subject;

  factory TeacherSubject.fromJson(Map<String, dynamic> json) => TeacherSubject(
        id: json['_id'],
        teacher: Teacher.fromJson(json['teacher']),
        course: Course.fromJson(json['course'][0]),
        subject: Subject.fromJson(json['subject'][0]),
      );
}

class AddTeacherSubject {
  AddTeacherSubject({this.teacherId, this.courseId, this.subjectId});
  String? courseId, subjectId, teacherId;

  Map<String, dynamic> toJson() => {
        "subjects": subjectId,
        "course": courseId,
        "teacher": teacherId,
      };
}
