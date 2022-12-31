class CustomTimer {
  final Duration duration;

  CustomTimer(this.duration, Future<void> Function() callback) {
    _start(callback);
  }

  bool _cancel = false;

  Future<void> _routine(Future<void> Function() callback) async {
    if (_cancel) {
      return;
    }
    await callback();
    await Future.delayed(duration);
    if (_cancel) {
      return;
    }
    _routine(callback);
  }

  void _start(Future<void> Function() callback) {
    _routine(callback);
  }

  void cancel() {
    _cancel = false;
  }
}
