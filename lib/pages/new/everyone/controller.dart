import 'package:expandable/expandable.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';

class EveryoneNewController extends GetxController {
  WorkType _workType = WorkType.illust;

  WorkType get workType => _workType;

  Restrict? _restrict;

  Restrict? get restrict => _restrict;

  final expandableController = ExpandableController();

  void restrictOnChanged(Restrict? value) {
    _restrict = value;
    update();
  }

  void workTypeOnChanged(WorkType value) {
    _workType = value;
    update();
  }
}
