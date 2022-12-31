import 'package:flutter/material.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/model/user_preview.dart';
import 'package:pixiv_func_mobile/components/user_previewer/user_previewer.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';

import 'source.dart';

class UserFollowingContent extends StatelessWidget {
  final int id;
  final Restrict restrict;

  const UserFollowingContent({Key? key, required this.id, required this.restrict}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataContent<UserPreview>(
      sourceList: UserFollowingListSource(id, restrict),
      itemBuilder: (BuildContext context, UserPreview item, bool visibility, int index) {
        return UserPreviewer(
          userPreview: item,
          useHero: visibility,
        );
      },
    );
  }
}
