// ------------------------------------------------------------ //
//  reactive_context.dart
//
//  Created by Siva Sankar on 2025-06-07.
// ------------------------------------------------------------ //


import 'package:flutter/foundation.dart';

/// A global context that tracks which reactive values are being accessed
/// during the build phase of a widget.
class ReactiveContext {
  static ReactiveContext? _current;
  
  /// The current reactive context, if any
  static ReactiveContext? get current => _current;
  
  /// Set of reactive values that have been accessed in this context
  final Set<ValueListenable> _accessedValues = {};
  
  /// Callbacks to execute when any accessed value changes
  final List<VoidCallback> _changeCallbacks = [];
  
  /// Run a function within this reactive context
  static T runInContext<T>(ReactiveContext context, T Function() fn) {
    final previous = _current;
    _current = context;
    try {
      return fn();
    } finally {
      _current = previous;
    }
  }
  
  /// Track access to a reactive value
  void trackAccess(ValueListenable listenable) {
    if (_accessedValues.add(listenable)) {
      // First time accessing this value, add listener
      listenable.addListener(_onValueChanged);
    }
  }
  
  /// Add a callback to execute when any tracked value changes
  void addChangeCallback(VoidCallback callback) {
    _changeCallbacks.add(callback);
  }
  
  /// Remove a change callback
  void removeChangeCallback(VoidCallback callback) {
    _changeCallbacks.remove(callback);
  }
  
  void _onValueChanged() {
    for (final callback in _changeCallbacks) {
      callback();
    }
  }
  
  /// Clean up all listeners and callbacks
  void dispose() {
    for (final listenable in _accessedValues) {
      listenable.removeListener(_onValueChanged);
    }
    _accessedValues.clear();
    _changeCallbacks.clear();
  }
}
