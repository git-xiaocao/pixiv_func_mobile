import 'dart:convert';
import 'dart:ui';

class I18nExpansion {
  const I18nExpansion({
    required this.locale,
    required this.title,
    required this.versionCode,
    required this.author,
    required this.github,
    required this.avatar,
    required this.data,
  });

  factory I18nExpansion.fromJson(Map<String, dynamic> json) => I18nExpansion(
        locale: json['locale'] as String,
        title: json['title'] as String,
        versionCode: json['versionCode'] as int,
        author: json['author'] as String,
        github: json['github'] as String,
        avatar: json['avatar'] as String,
        data: (json['data'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as String)),
      );

  final String locale;
  final String title;
  final int versionCode;
  final String author;
  final String github;
  final String avatar;
  final Map<String, String> data;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'locale': locale,
        'title': title,
        'versionCode': versionCode,
        'author': author,
        'github': github,
        'avatar': avatar,
        'data': data,
      };

  Locale get flutterLocale {
    final list = locale.split('_');
    return Locale(list.first, list.last);
  }
}
