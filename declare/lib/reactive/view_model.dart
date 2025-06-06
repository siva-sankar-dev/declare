import 'package:flutter/foundation.dart';

abstract class ViewModel extends ChangeNotifier {
  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  @mustCallSuper
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void onInit() {}
}
