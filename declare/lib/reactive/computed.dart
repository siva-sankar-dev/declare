// ------------------------------------------------------------ //
//  computed.dart
//
//  Created by Siva Sankar on 2025-06-06.
// ------------------------------------------------------------ //


import 'package:declare/reactive/reactive_context.dart';
import 'package:flutter/foundation.dart';

class Computed<T> implements ValueListenable<T> {
  final T Function() _compute;
  final List<ValueListenable> _dependencies;
  late T _value;
  final List<VoidCallback> _listeners = [];
  bool _disposed = false;

  Computed(this._compute, this._dependencies) {
    _value = _compute();
    
    // Listen to all dependencies
    for (final dep in _dependencies) {
      dep.addListener(_onDependencyChanged);
    }
  }

  void _onDependencyChanged() {
    if (_disposed) return;
    
    final newValue = _compute();
    if (_value != newValue) {
      _value = newValue;
      for (final listener in _listeners) {
        listener();
      }
    }
  }

  @override
  T get value {
    // Track access in the current reactive context
    ReactiveContext.current?.trackAccess(this);
    return _value;
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    
    for (final dep in _dependencies) {
      dep.removeListener(_onDependencyChanged);
    }
    _listeners.clear();
  }
}
