// ------------------------------------------------------------ //
//  view_model.dart
//
//  Created by Siva Sankar on 2025-06-07.
// ------------------------------------------------------------ //


import 'package:flutter/foundation.dart';
import 'reactive.dart';

abstract class ViewModel extends ChangeNotifier {
  final Set<ValueListenable> _cells = {};
  final Set<Computed> _computedValues = {};
  bool _disposed = false;

  /// Create a reactive state
  Prop<T> state<T>(T initialValue) {
    final state = Prop<T>(initialValue);
    state.setParent(this);
    _cells.add(state);
    return state;
  }

  /// Create a published (nullable) state
  Published<T> published<T>([T? initialValue]) {
    final published = Published<T>(initialValue);
    published.setParent(this);
    _cells.add(published);
    return published;
  }

  /// Create a computed value
  Computed<T> computed<T>(
    T Function() compute,
    List<ValueListenable> dependencies,
  ) {
    final computed = Computed<T>(compute, dependencies);
    _computedValues.add(computed);
    return computed;
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  /// Called when the ViewModel is first created
  void onInit() {}

  /// Called when the ViewModel is about to be disposed
  void onDispose() {}

  @override
  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _disposed = true;

    onDispose();

    // Dispose all reactive states
    for (final state in _cells) {
      if (state is Prop) {
        state.dispose();
      } else if (state is Published) {
        state.dispose();
      }
    }
    _cells.clear();

    // Dispose all computed values
    for (final computed in _computedValues) {
      computed.dispose();
    }
    _computedValues.clear();

    super.dispose();
  }
}