class SearchImageResult {
  final String imageUrl;
  final String? sourceUrl;
  final String? sourceText;

  ///相似度
  final String similarityText;
  final List<SearchImageMiscInfo> miscInfoList;

  SearchImageResult({
    required this.imageUrl,
    required this.sourceUrl,
    required this.sourceText,
    required this.similarityText,
    required this.miscInfoList,
  });

  bool get isPixivIllust => true == sourceUrl?.startsWith('https://www.pixiv.net/') && true == sourceUrl?.contains('illust_id');

  int get illustId => sourceUrl != null ? int.tryParse(Uri.parse(sourceUrl!).queryParameters['illust_id'] ?? '') ?? -1 : -1;
}

class SearchImageMiscInfo {
  final String url;
  final String imageUrl;

  SearchImageMiscInfo({required this.url, required this.imageUrl});
}
