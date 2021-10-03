/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:recommended_novel_model.dart
 * 创建时间:2021/10/3 下午4:27
 * 作者:小草
 */
import 'package:pixiv_func_android/api/entity/novel.dart';
import 'package:pixiv_func_android/api/model/novels.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class RecommendedNovelModel extends BaseViewStateRefreshListModel<Novel> {

  RecommendedNovelModel();

  @override
  Future<List<Novel>> loadFirstDataRoutine() async {
    final result = await pixivAPI.getRecommendedNovels();
    nextUrl = result.nextUrl;

    return result.novels;
  }

  @override
  Future<List<Novel>> loadNextDataRoutine() async {
    final result = await pixivAPI.next<Novels>(nextUrl!);

    nextUrl = result.nextUrl;

    return result.novels;
  }
}