import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixiv_func_mobile/pages/search/result/image/search_image_result.dart';

class SearchImagePage extends StatefulWidget {
  const SearchImagePage({Key? key}) : super(key: key);

  @override
  State<SearchImagePage> createState() => _SearchImagePageState();
}

class _SearchImagePageState extends State<SearchImagePage> {
  Uint8List? imageBytes;

  String? filename;

  @override
  void initState() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((picker) async {
      if (null != picker) {
        final bytes = await picker.readAsBytes();
        setState(() {
          imageBytes = bytes;
          filename = picker.name;
        });
      } else {
        Get.back();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (null == imageBytes) {
      return const SizedBox();
    } else {
      return SearchImageResultPage(imageBytes: imageBytes!, filename: filename!);
    }
  }
}
