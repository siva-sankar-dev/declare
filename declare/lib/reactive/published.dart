import 'package:flutter/foundation.dart';

class Published<T> extends ChangeNotifier {
  T? _value;

  Published([this._value]);

  T? get value => _value;

  set value(T? newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}
