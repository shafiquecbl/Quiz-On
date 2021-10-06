import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_on/Provider/provider.dart';

class MyPageController {
  static PageController controller =
      PageController(initialPage: 0, keepPage: false);

  void changePage(BuildContext context, int index) {
    CustomProvier provider = Provider.of(context, listen: false);
    provider.changeCurrentPage(index: index);
    controller.jumpToPage(index);
  }
}
