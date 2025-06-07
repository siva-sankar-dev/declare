// ------------------------------------------------------------ //
//  published.dart
//
//  Created by Siva Sankar on 2025-06-06.
// ------------------------------------------------------------ //

import 'package:declare/reactive/tracked_reactive_value';
import 'package:flutter/foundation.dart';

class Published<T> extends ValueNotifier<T?> with TrackedValueMixin<T?> {
  Published([super.initialValue]);

  /// Optional parent that gets notified when this value changes
  ChangeNotifier? _parent;

  void setParent(ChangeNotifier parent) {
    _parent = parent;
  }

  @override
  set value(T? newValue) {
    if (super.value != newValue) {
      super.value = newValue;
      _parent?.notifyListeners();
    }
  }

  /// Update value and notify listeners
  void update(T? newValue) {
    value = newValue;
  }

  /// Clear the value (set to null)
  void clear() {
    value = null;
  }

  /// Check if has value
  bool get hasValue => value != null;

  @override
  void dispose() {
    _parent = null;
    super.dispose();
  }
}
