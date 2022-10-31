import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/tag.dart';
import 'package:pixiv_func_mobile/app/services/block_tag_service.dart';

class BlockTagController extends GetxController {
  final List<Tag> list = [];
  final BlockTagService blockTagService = Get.find();

  void blockTagChangeState(Tag tag) {
    if (blockTagService.isBlocked(tag)) {
      blockTagService.remove(tag);
    } else {
      blockTagService.add(tag);
    }
    update();
  }

  @override
  void onInit() {
    list.addAll(blockTagService.blockTags);

    super.onInit();
  }
}
