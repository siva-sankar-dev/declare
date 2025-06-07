// ------------------------------------------------------------ //
//  reactive_value.dart
//
//  Created by Siva Sankar on 2025-06-06.
// ------------------------------------------------------------ //

import 'package:declare/reactive/tracked_reactive_value';
import 'package:flutter/foundation.dart';

abstract class ReactiveValue<T> extends ValueNotifier<T> with TrackedValueMixin<T> {
  ReactiveValue(super.value);
  
  /// Optional parent that gets notified when this value changes
  ChangeNotifier? _parent;
  
  void setParent(ChangeNotifier parent) {
    _parent = parent;
  }
  
  @override
  T _getRawValue() => super.value;
  
  @override
  set value(T newValue) {
    if (super.value != newValue) {
      super.value = newValue;
      _parent?.notifyListeners();
    }
  }
  
  @override
  void dispose() {
    _parent = null;
    super.dispose();
  }
}
