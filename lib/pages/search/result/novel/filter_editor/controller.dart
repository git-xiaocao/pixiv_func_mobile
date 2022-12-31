import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/models/search_filter.dart';
import 'package:pixiv_func_mobile/app/services/account_service.dart';

class SearchNovelFilterEditorController extends GetxController {
  final VoidCallback onFilterChanged;

  SearchNovelFilterEditorController(this.onFilterChanged);

  final editFilterPanelController = ExpandableController();

  final SearchNovelFilter filter = SearchNovelFilter.create();

  final filterItems = <int, bool?>{};

  bool _editFilter = false;

  int get editFilterIndex => filterItems.keys.toList().firstWhereOrNull((key) => filterItems[key] == true) ?? -1;

  void editFilterChangeState(int index) {
    if (filterItems[index] == null) {
      filterItems.clear();
      filterItems[index] = true;
    } else {
      filterItems.clear();
    }
    _editFilter = filterItems.values.contains(true);
    editFilterPanelController.expanded = _editFilter;
    update();
  }

  SearchNovelTarget get target => filter.target;

  SearchSort get sort => filter.sort;

  bool get enableDateRange => filter.enableDateRange;

  DateTimeRange get dateRange => filter.dateRange;

  String get startDate => filter.formatStartDate;

  String get endDate => filter.formatEndDate;

  int? get bookmarkTotal => filter.bookmarkTotal;

  int get dateRangeType => filter.dateRangeType;

  final bookmarkTotalItems = <int?>[
    null,
    100,
    250,
    500,
    1000,
    5000,
    7500,
    10000,
    20000,
    30000,
    50000,
    100000,
  ];

  int get bookmarkTotalSelected => bookmarkTotalItems.indexWhere((item) {
        return item == filter.bookmarkTotal;
      });

  String get bookmarkTotalText {
    final item = bookmarkTotalItems[bookmarkTotalSelected];
    if (null == item) {
      return I18n.searchBookmarkCountNo.tr;
    } else {
      return I18n.searchBookmarkCountMore.trArgs([item.toString()]);
    }
  }

  void searchNovelTargetOnChanged(SearchNovelTarget? value) {
    if (null != value) {
      filter.target = value;
      update();
      onFilterChanged();
    }
  }

  void searchSortOnChanged(SearchSort? value) {
    if (null != value) {
      if (SearchSort.popularDesc == value && !Get.find<AccountService>().current!.isPremium) {
        PlatformApi.toast(I18n.notPremiumHint.tr);
      }
      filter.sort = value;
      update();
      onFilterChanged();
    }
  }

  void enableDateRangeOnChanged(bool? value) {
    if (null != value) {
      filter.enableDateRange = value;
      update();
      onFilterChanged();
    }
  }

  void dateRangeOnChanged(DateTimeRange? value) {
    if (null != value) {
      filter.dateRange = value;
      update();
      onFilterChanged();
    }
  }

  void bookmarkTotalOnChanged(int? value) {
    if (null != value) {
      filter.bookmarkTotal = value;
      update();
      onFilterChanged();
    }
  }

  void dateTimeRangeTypeOnChanged(int? value) {
    if (null != value) {
      filter.dateRangeType = value;
      update();
      onFilterChanged();
    }
  }

  void bookmarkTotalSliderOnChange(double value) {
    filter.bookmarkTotal = bookmarkTotalItems[value.round()];
    update();
    onFilterChanged();
  }
}
