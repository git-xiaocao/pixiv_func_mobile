import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/widgets/lazy_indexed_stack/lazy_indexed_stack.dart';
import 'package:pixiv_func_mobile/pages/new/new.dart';
import 'package:pixiv_func_mobile/pages/ranking/ranking.dart';
import 'package:pixiv_func_mobile/pages/recommended/recommended.dart';
import 'package:pixiv_func_mobile/pages/search_guide/search_guide.dart';
import 'package:pixiv_func_mobile/pages/settings/settings.dart';

import 'controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final navigationItems = [
      AppIcons.home,
      AppIcons.ranking,
      AppIcons.n,
      AppIcons.search,
      Icons.settings,
    ];
    return GetBuilder<HomeController>(
      builder: (controller) => Scaffold(
        body: LazyIndexedStack(
          index: controller.index,
          children: const [
            RecommendedPage(),
            RankingPage(),
            NewPage(),
            SearchGuidePage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).colorScheme.background,
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                for (int i = 0; i < navigationItems.length; i++)
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        controller.index = i;
                      },
                      child: Padding(
                        // alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Icon(
                          navigationItems[i],
                          color: controller.index == i ? Theme.of(context).colorScheme.primary : null,
                          size: 35,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
