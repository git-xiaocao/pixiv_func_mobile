import 'dart:convert';

import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_account_result.dart';
import 'package:pixiv_func_mobile/models/account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountService extends GetxService {
  static const _dataKeyName = "accounts";
  static const _dataIndexKeyName = "account_index";

  final Rx<List<Account>> accounts = Rx([]);

  late final SharedPreferences _sharedPreferences;

  late final RxInt currentIndex;

  List<String>? tempAccountList;

  Future<void> refreshAccountList() async {
    await _sharedPreferences.reload();

    final currentAccounts = _sharedPreferences.getStringList(_dataKeyName);
    if (null != currentAccounts && tempAccountList != currentAccounts) {
      accounts().clear();
      accounts().addAll(
        currentAccounts.map(
          (jsonString) {
            final json = jsonDecode(jsonString);
            return Account.fromJson(json);
          },
        ),
      );
    }
  }

  Future<AccountService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    final tempAccounts = _sharedPreferences.getStringList(_dataKeyName);
    if (null != tempAccounts) {
      accounts().addAll(
        tempAccounts.map(
          (jsonString) {
            final json = jsonDecode(jsonString);
            return Account.fromJson(json);
          },
        ),
      );
    }
    currentIndex = RxInt(_sharedPreferences.getInt(_dataIndexKeyName) ?? (accounts().isNotEmpty ? 0 : -1));
    return this;
  }

  ///保存账号
  void save() {
    _sharedPreferences.setStringList(_dataKeyName, accounts().map((account) => jsonEncode(account.toJson())).toList());
  }

  void select(int index) async {
    currentIndex.value = index;
    // Get.find<ChatListController>().refreshTimer();
    _sharedPreferences.setInt(_dataIndexKeyName, index);
  }

  ///添加账号
  void add(Account account) {
    //如果已经存在就更新
    if (accounts().any((element) => element.userId == account.userId)) {
      update(account);
    } else {
      accounts.update((val) {
        val?.add(account);
      });
      if (1 == accounts().length) {
        select(0);
      } else {
        select(accounts().length - 1);
      }
      save();
    }
  }

  ///更新账号
  void update(Account account) {
    accounts.update((val) {
      if (null != val) {
        for (int i = 0; i < val.length; i++) {
          if (account.userId == val[i].userId) {
            val[i] = account;
            save();
            break;
          }
        }
      }
    });
  }

  void updateUserAccount(UserAccountResult userAccount) {
    accounts.update((val) {
      if (null != val) {
        for (int i = 0; i < val.length; i++) {
          if (userAccount.user.id == val[i].userAccount.user.id) {
            val[i] = Account(val[i].cookie, userAccount);
            save();
            break;
          }
        }
      }
    });
  }

  ///移除账号
  void remove(Account account) {
    accounts.update((val) {
      val?.remove(account);
    });
    save();
  }

  ///移除账号
  void removeAt(int i) {
    accounts.update((val) {
      val?.removeAt(i);
    });
    save();
  }

  Account? get current {
    if (-1 == currentIndex.value) {
      return null;
    }
    return accounts()[currentIndex.value];
  }

  int get currentUserId => current!.userId;

  bool get isEmpty => accounts().isEmpty;

  bool get isNotEmpty => accounts().isNotEmpty;
}
