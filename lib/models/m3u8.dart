class M3u8 {
  final int bandwidth;
  final Resolution resolution;
  final Uri uri;

  M3u8._(this.bandwidth, this.resolution, this.uri);

  static List<M3u8> parse(String m3u8) {
    final list = <M3u8>[];
    final lines = m3u8.split('\r\n');
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.startsWith('#EXT-X-STREAM-INF')) {
        final bandwidthStartIndex = line.indexOf('BANDWIDTH=') + 'BANDWIDTH='.length;
        final bandwidthEndIndex = line.indexOf(',', bandwidthStartIndex);
        final resolutionStartIndex = line.indexOf('RESOLUTION=') + 'RESOLUTION='.length;

        final url = lines[i + 1];
        list.add(
          M3u8._(
            int.parse(line.substring(bandwidthStartIndex, bandwidthEndIndex)),
            Resolution.formString(line.substring(resolutionStartIndex)),
            Uri.parse(url),
          ),
        );
      }
    }
    return list;
  }
}

class Resolution {
  final int width;
  final int height;

  Resolution._(this.width, this.height);

  factory Resolution.formString(String resolution) {
    final List<String> resolutionList = resolution.split('x');
    return Resolution._(int.parse(resolutionList[0]), int.parse(resolutionList[1]));
  }

  @override
  String toString() {
    return '$width × $height';
  }
}
