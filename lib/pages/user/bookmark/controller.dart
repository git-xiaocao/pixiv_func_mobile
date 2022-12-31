import 'package:expandable/expandable.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';

class UserBookmarkController extends GetxController {
  WorkType _workType = WorkType.illust;

  WorkType get workType => _workType;

  final expandableController = ExpandableController();

  void workTypeOnChanged(WorkType value) {
    _workType = value;
    update();
  }
}
