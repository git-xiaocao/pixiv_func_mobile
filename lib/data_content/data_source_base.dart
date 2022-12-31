import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_mobile/app/services/block_tag_service.dart';

abstract class DataSourceBase<T> extends LoadingMoreBase<T> {
  final BlockTagService blockTagService = Get.find();
  bool initData = false;
  String? nextUrl;

  @override
  bool get hasMore => !initData || null != nextUrl;
  final CancelToken _cancelToken = CancelToken();

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) async {
    initData = false;
    nextUrl = null;
    final result = super.refresh(notifyStateChanged);
    return result;
  }

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        addAll(blockTagService.noBlockedList(await init(_cancelToken)));
        initData = true;
      } else {
        if (hasMore) {
          addAll(blockTagService.noBlockedList(await next(_cancelToken)));
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<T>> init(CancelToken cancelToken);

  Future<List<T>> next(CancelToken cancelToken);

  String tag();

  @override
  bool operator ==(Object other) => identical(this, other) || other is DataSourceBase && tag() == other.tag();

  @override
  int get hashCode => tag().hashCode;

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }
}
