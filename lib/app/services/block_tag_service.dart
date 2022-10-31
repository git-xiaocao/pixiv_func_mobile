import 'dart:convert';

import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_dart_api/model/tag.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockTagService extends GetxService {
  static const _dataKeyName = "block_tags";
  late final SharedPreferences _sharedPreferences;

  final List<Tag> blockTags = [];

  Future<BlockTagService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    final tempShieldTags = _sharedPreferences.getStringList(_dataKeyName);
    if (null != tempShieldTags) {
      blockTags.addAll(
        tempShieldTags.map(
          (jsonString) {
            final json = jsonDecode(jsonString);
            return Tag.fromJson(json);
          },
        ),
      );
    }

    return this;
  }

  //保存
  void save() {
    _sharedPreferences.setStringList(_dataKeyName, blockTags.map((tag) => jsonEncode(tag.toJson())).toList());
  }

  //添加
  void add(Tag tag) {
    if (blockTags.any((element) => element.name == tag.name)) {
      return;
    }
    blockTags.add(tag);
    save();
  }

  //删除
  void remove(Tag tag) {
    blockTags.remove(tag);
    save();
  }

  //是否被屏蔽
  bool isBlocked(Tag tag) {
    return blockTags.any((element) => element.name == tag.name);
  }

  List<T> noBlockedList<T>(List<T> list) {
    if (blockTags.isEmpty) {
      return list;
    }
    if (T == Illust) {
      return list.where((item) => (item as Illust).tags.every((tag) => !isBlocked(tag))).toList(); //排除被屏蔽的标签
    } else if (T == Novel) {
      return list.where((item) => (item as Novel).tags.every((tag) => !isBlocked(tag))).toList(); //排除被屏蔽的标签
    } else {
      return list;
    }
  }
}
