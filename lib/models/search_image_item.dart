import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/models/search_image_result.dart';

class SearchImageItem {
  Illust? illust;
  SearchImageResult result;
  bool loading = false;
  bool loadFailed = false;

  SearchImageItem(this.result);
}
