import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_on/Controller/page_controller.dart';
import 'package:quiz_on/Models/Student/student_subjects.dart';
import 'package:quiz_on/Provider/provider.dart';
import 'package:quiz_on/Services/api_manager.dart';
import 'package:quiz_on/WIdgets/loading.dart';
import 'package:quiz_on/WIdgets/network_error.dart';
import 'package:quiz_on/Widgets/custom_card.dart';

class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  MyPageController controller = MyPageController();
  Future<List<StudentSubject>>? subjectModel;

  @override
  void initState() {
    getSubjects();
    super.initState();
  }

  getSubjects() {
    CustomProvier provider = Provider.of<CustomProvier>(context, listen: false);
    subjectModel = APIManager().getStudentSubjects(
        token: provider.loginResponse!.token, id: provider.course!.course!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: FutureBuilder<List<StudentSubject>>(
        future: subjectModel,
        builder: (BuildContext context,
            AsyncSnapshot<List<StudentSubject>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return MyLoading();
          if (snapshot.data == null)
            return NetworkError(onPressed: () {
              updatePage();
            });
          if (snapshot.data!.length == 0)
            return Center(
              child: Text('No Subjects available.'),
            );
          return subjectsList(list: snapshot.data!);
        },
      ),
    );
  }

  subjectsList({@required List<StudentSubject>? list}) {
    return GridView.builder(
        itemCount: list!.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 3 / 2.3,
            crossAxisSpacing: 25,
            mainAxisSpacing: 25),
        itemBuilder: (context, index) {
          return subject(subject: list[index]);
        });
  }

  subject({@required StudentSubject? subject}) {
    return CourseCard(
      text: subject!.subjectName.toString(),
      onPressed: () {
        CustomProvier provider =
            Provider.of<CustomProvier>(context, listen: false);
        provider.saveStudentSubject(studentSubject: subject);
        provider.changeCurrentPage(index: 2);
        controller.changePage(context, 2);
      },
      icon: Icons.library_books_outlined,
    );
  }

  updatePage() {
    CustomProvier provider = Provider.of(context, listen: false);
    setState(() {
      subjectModel = APIManager().getStudentSubjects(
          token: provider.loginResponse!.token,
          id: provider.course!.course!.id);
    });
  }
}
