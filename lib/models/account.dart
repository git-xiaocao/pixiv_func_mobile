import 'package:pixiv_dart_api/model/local_user.dart';
import 'package:pixiv_dart_api/vo/user_account_result.dart';

class Account {
  final String? cookie;
  final UserAccountResult userAccount;

  Account(this.cookie, this.userAccount);

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        json['cookie'] as String,
        UserAccountResult.fromJson(json['userAccount'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() {
    return {
      'cookie': cookie,
      'userAccount': userAccount.toJson(),
    };
  }

  int get userId => int.parse(userAccount.user.id);

  String get mailAddress => userAccount.user.mailAddress;

  LocalUser get localUser => userAccount.user;

  bool get isPremium => userAccount.user.isPremium;
}
