import 'dart:convert';

import 'package:flutter/services.dart';

class AssetManifest {
  List<AssetFileInfo> assets;
  List<AssetFileInfo> emojis;
  List<AssetFileInfo> stamps;

  AssetManifest(this.assets, this.emojis, this.stamps);

  factory AssetManifest.formString(String s) {
    final list = (jsonDecode(s) as Map<String, dynamic>).keys.where((e) => e.split('/').first == 'assets').toList();
    final Map<String, List<AssetFileInfo>> map = {};
    for (final fullPath in list) {
      final path = fullPath.split('/')[fullPath.split('/').length - 2];
      final fullName = fullPath.split('/').last;
      final name = fullName.split('.').first;
      if (map.containsKey(path)) {
        map[path]!.add(AssetFileInfo(fullPath, name, fullName));
      } else {
        map[path] = [
          AssetFileInfo(fullPath, name, fullName),
        ];
      }
    }

    return AssetManifest(map['assets']!, map['emojis']!, map['stamps']!);
  }
}

class AssetFileInfo {
  final String fullPath;
  final String name;
  final String fullName;

  AssetFileInfo(this.fullPath, this.name, this.fullName);
}

late final AssetManifest assetManifest;

Future<void> initAssetManifest() async {
  final String s = await rootBundle.loadString('AssetManifest.json');
  assetManifest = AssetManifest.formString(s);
}
