import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_on/Controller/page_controller.dart';
import 'package:quiz_on/Models/Student/student_courses.dart';
import 'package:quiz_on/Provider/provider.dart';
import 'package:quiz_on/Services/api_manager.dart';
import 'package:quiz_on/WIdgets/loading.dart';
import 'package:quiz_on/WIdgets/network_error.dart';
import 'package:quiz_on/Widgets/custom_card.dart';

class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  MyPageController controller = MyPageController();
  Future<List<StudentCourse>>? courseModel;

  @override
  void initState() {
    getStudentCourse();
    super.initState();
  }

  getStudentCourse() {
    CustomProvier provider = Provider.of(context, listen: false);
    courseModel = APIManager().getStudentCourses(
        token: provider.loginResponse!.token,
        id: provider.loginResponse!.user!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: FutureBuilder<List<StudentCourse>>(
        future: courseModel,
        builder: (BuildContext context,
            AsyncSnapshot<List<StudentCourse>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return MyLoading();
          if (snapshot.data == null)
            return NetworkError(onPressed: () {
              updatePage();
            });
          if (snapshot.data!.length == 0)
            return Center(
              child: Text('No Courses yet!'),
            );
          return coursesList(list: snapshot.data!);
        },
      ),
    );
  }

  coursesList({@required List<StudentCourse>? list}) {
    return GridView.builder(
        itemCount: list!.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 3 / 2.3,
            crossAxisSpacing: 25,
            mainAxisSpacing: 25),
        itemBuilder: (context, index) {
          return course(course: list[index]);
        });
  }

  course({@required StudentCourse? course}) {
    return CourseCard(
      text: course!.course!.name.toString(),
      onPressed: () {
        CustomProvier provider =
            Provider.of<CustomProvier>(context, listen: false);
        provider.saveStudentCourse(studentCourse: course);
        provider.changeCurrentPage(index: 1);
        controller.changePage(context, 1);
      },
      icon: Icons.library_books_outlined,
    );
  }

  updatePage() {
    CustomProvier provider = Provider.of(context, listen: false);
    setState(() {
      courseModel = APIManager().getStudentCourses(
          token: provider.loginResponse!.token,
          id: provider.loginResponse!.user!.id);
    });
  }
}
