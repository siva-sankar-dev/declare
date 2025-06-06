// ------------------------------------------------------------ //
//  reactive_value.dart
//
//  Created by Siva Sankar on 2025-06-06.
// ------------------------------------------------------------ //

import 'package:flutter/foundation.dart';

abstract class ReactiveValue<T> extends ValueNotifier<T> {
  ReactiveValue(super.value);
  
  /// Optional parent that gets notified when this value changes
  ChangeNotifier? _parent;
  
  void setParent(ChangeNotifier parent) {
    _parent = parent;
  }
  
  @override
  set value(T newValue) {
    if (value != newValue) {
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