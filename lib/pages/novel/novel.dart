import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/components/novel_viewer/novel_viewer.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class NovelPage extends StatelessWidget {
  final Novel novel;

  const NovelPage({Key? key, required this.novel}) : super(key: key);

  String get tag => '${novel.id}';

  @override
  Widget build(BuildContext context) {
    Get.put(NovelController(novel.id), tag: tag);
    return GetBuilder<NovelController>(
      tag: tag,
      builder: (controller) => ScaffoldWidget(
        title: novel.title,
        child: Padding(
          padding: MediaQuery.of(context).padding.copyWith(left: 0, right: 0, top: 0),
          child: () {
            if (PageState.loading == controller.state) {
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            } else if (PageState.error == controller.state) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.loadData(),
                child: Container(
                  alignment: Alignment.center,
                  child: const TextWidget('加载失败,点击重试', fontSize: 16),
                ),
              );
            } else if (PageState.notFound == controller.state) {
              return Container(
                alignment: Alignment.center,
                child: TextWidget('小说ID${novel.id}不存在', fontSize: 16),
              );
            } else {
              return NovelViewer(text: controller.novelJSData!.text, id: novel.id);
            }
          }(),
        ),
      ),
    );
  }
}
