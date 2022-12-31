import 'dart:typed_data';

class PickedImageInfo {
  Uint8List bytes;
  String filename;

  PickedImageInfo(this.bytes, this.filename);
}
