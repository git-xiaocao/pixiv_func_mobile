import 'package:pixiv_dart_api/enums.dart';

class BookmarkedFilter {
  Restrict restrict;
  String? tag;

  //未分类(日语)
  static const uncategorized = '未分類';

  BookmarkedFilter({required this.restrict, required this.tag});

  factory BookmarkedFilter.create() => BookmarkedFilter(
        restrict: Restrict.public,
        tag: null,
      );

  factory BookmarkedFilter.copy(BookmarkedFilter filter) => BookmarkedFilter(
        restrict: filter.restrict,
        tag: filter.tag,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkedFilter && runtimeType == other.runtimeType && restrict == other.restrict && tag == other.tag;

  @override
  int get hashCode => restrict.hashCode ^ tag.hashCode;
}
