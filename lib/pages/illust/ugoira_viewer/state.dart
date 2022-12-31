import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:pixiv_dart_api/vo/ugoira_metadata_result.dart';

class UgoiraViewerState {
  final List<Uint8List> imageFiles = [];

  final List<ui.Image> images = [];

  final List<int> delays = [];

  ui.Size size = ui.Size.zero;

  UgoiraMetadataResult? ugoiraMetadata;

  Response<Uint8List>? gifZipResponse;

  bool loaded = false;

  bool loading = false;

  bool init = false;
}
