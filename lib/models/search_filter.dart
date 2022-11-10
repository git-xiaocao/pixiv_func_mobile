import 'package:flutter/material.dart';
import 'package:pixiv_dart_api/enums.dart';

class SearchIllustFilter {
  SearchIllustTarget target;
  SearchSort sort;
  bool enableDateRange;
  DateTimeRange dateRange;
  int? bookmarkTotal;
  int dateRangeType;

  SearchIllustFilter({
    required this.target,
    required this.sort,
    required this.enableDateRange,
    required this.dateRange,
    required this.bookmarkTotal,
    required this.dateRangeType,
  });

  ///因为Dart直接传对线是引用类型 所以需要创建一个副本 用于编辑
  factory SearchIllustFilter.copy(SearchIllustFilter filter) => SearchIllustFilter(
        target: filter.target,
        sort: filter.sort,
        enableDateRange: filter.enableDateRange,
        dateRange: filter.dateRange,
        bookmarkTotal: filter.bookmarkTotal,
        dateRangeType: filter.dateRangeType,
      );

  factory SearchIllustFilter.create({
    SearchIllustTarget target = SearchIllustTarget.partialMatchForTags,
    SearchSort sort = SearchSort.dateDesc,
    bool enableDateLimit = false,
  }) {
    final DateTime currentDate = DateTime.now();
    return SearchIllustFilter(
      target: target,
      sort: sort,
      enableDateRange: enableDateLimit,
      dateRange: DateTimeRange(
        start: DateTime(currentDate.year - 1, currentDate.month, currentDate.day),
        end: DateTime(currentDate.year, currentDate.month, currentDate.day),
      ),
      bookmarkTotal: null,
      dateRangeType: 0,
    );
  }

  String get formatStartDate => '${dateRange.start.year}-${dateRange.start.month}-${dateRange.start.day}';

  String get formatEndDate => '${dateRange.end.year}-${dateRange.end.month}-${dateRange.end.day}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchIllustFilter &&
          runtimeType == other.runtimeType &&
          target == other.target &&
          sort == other.sort &&
          enableDateRange == other.enableDateRange &&
          dateRange == other.dateRange &&
          bookmarkTotal == other.bookmarkTotal &&
          dateRangeType == other.dateRangeType;

  @override
  int get hashCode =>
      target.hashCode ^ sort.hashCode ^ enableDateRange.hashCode ^ dateRange.hashCode ^ bookmarkTotal.hashCode ^ dateRangeType.hashCode;
}

class SearchNovelFilter {
  SearchNovelTarget target;
  SearchSort sort;
  bool enableDateRange;
  DateTimeRange dateRange;
  int? bookmarkTotal;
  int dateRangeType;

  SearchNovelFilter({
    required this.target,
    required this.sort,
    required this.enableDateRange,
    required this.dateRange,
    required this.bookmarkTotal,
    required this.dateRangeType,
  });

  ///因为Dart直接传对线是引用类型 所以需要创建一个副本 用于编辑
  factory SearchNovelFilter.copy(SearchNovelFilter filter) => SearchNovelFilter(
        target: filter.target,
        sort: filter.sort,
        enableDateRange: filter.enableDateRange,
        dateRange: filter.dateRange,
        bookmarkTotal: filter.bookmarkTotal,
        dateRangeType: filter.dateRangeType,
      );

  factory SearchNovelFilter.create({
    SearchNovelTarget target = SearchNovelTarget.partialMatchForTags,
    SearchSort sort = SearchSort.dateDesc,
    bool enableDateLimit = false,
  }) {
    final DateTime currentDate = DateTime.now();
    return SearchNovelFilter(
      target: target,
      sort: sort,
      enableDateRange: enableDateLimit,
      dateRange: DateTimeRange(
        start: DateTime(currentDate.year - 1, currentDate.month, currentDate.day),
        end: DateTime(currentDate.year, currentDate.month, currentDate.day),
      ),
      bookmarkTotal: null,
      dateRangeType: 0,
    );
  }

  String get formatStartDate => '${dateRange.start.year}-${dateRange.start.month}-${dateRange.start.day}';

  String get formatEndDate => '${dateRange.end.year}-${dateRange.end.month}-${dateRange.end.day}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchIllustFilter &&
          runtimeType == other.runtimeType &&
          target == other.target &&
          sort == other.sort &&
          enableDateRange == other.enableDateRange &&
          dateRange == other.dateRange &&
          bookmarkTotal == other.bookmarkTotal &&
          dateRangeType == other.dateRangeType;

  @override
  int get hashCode =>
      target.hashCode ^ sort.hashCode ^ enableDateRange.hashCode ^ dateRange.hashCode ^ bookmarkTotal.hashCode ^ dateRangeType.hashCode;
}
