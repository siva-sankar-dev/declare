// ------------------------------------------------------------ //
//  state.dart
//
//  Created by Siva Sankar on 2025-06-06.
// ------------------------------------------------------------ //

import 'package:declare/reactive/reactive_value.dart';
class State<T> extends ReactiveValue<T> {
  State(super.initialValue);
  
  /// Update value and notify listeners
  void update(T newValue) {
    value = newValue;
  }
  
  /// Transform current value
  void transform(T Function(T current) transformer) {
    value = transformer(value);
  }
}


