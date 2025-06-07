// ------------------------------------------------------------ //
//  reactive.dart
//
//  Created by Siva Sankar on 2025-06-07.
// ------------------------------------------------------------ //

import 'package:flutter/foundation.dart';

// ------------------------------------------------------------ //
// REACTIVE CONTEXT
// ------------------------------------------------------------ //

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

// ------------------------------------------------------------ //
// TRACKED VALUE MIXIN
// ------------------------------------------------------------ //

/// A mixin that adds automatic tracking capabilities to reactive values
mixin TrackedValueMixin<T> on ValueListenable<T> {
  /// Subclasses must implement this to return the actual value
  T _getRawValue();

  @override
  T get value {
    // Track access in the current reactive context
    ReactiveContext.current?.trackAccess(this);
    return _getRawValue();
  }
}

// ------------------------------------------------------------ //
// REACTIVE VALUE BASE CLASS
// ------------------------------------------------------------ //

abstract class ReactiveValue<T> extends ValueNotifier<T>
    with TrackedValueMixin<T> {
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

// ------------------------------------------------------------ //
// PROP - MUTABLE REACTIVE STATE
// ------------------------------------------------------------ //

class Prop<T> extends ReactiveValue<T> {
  Prop(super.initialValue);

  /// Update value and notify listeners
  void update(T newValue) {
    value = newValue;
  }

  /// Transform current value
  void transform(T Function(T current) transformer) {
    value = transformer(value);
  }
}

// ------------------------------------------------------------ //
// PUBLISHED - NULLABLE REACTIVE STATE
// ------------------------------------------------------------ //

class Published<T> extends ValueNotifier<T?> with TrackedValueMixin<T?> {
  Published([super.initialValue]);

  /// Optional parent that gets notified when this value changes
  ChangeNotifier? _parent;

  void setParent(ChangeNotifier parent) {
    _parent = parent;
  }

  @override
  T? _getRawValue() => super.value;

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

// ------------------------------------------------------------ //
// COMPUTED - DERIVED VALUES
// ------------------------------------------------------------ //

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

// ------------------------------------------------------------ //
// EXTENSIONS
// ------------------------------------------------------------ //

/// Reactive Extensions
extension ReactiveExtensions<T> on ValueListenable<T> {
  /// Map this reactive value to another type
  Computed<R> map<R>(R Function(T value) mapper) {
    return Computed<R>(() => mapper(value), [this]);
  }

  /// Filter changes based on a condition
  Computed<T> where(bool Function(T value) predicate) {
    return Computed<T>(() => value, [this]);
  }

  /// Combine with another reactive value
  Computed<R> combine<U, R>(
    ValueListenable<U> other,
    R Function(T a, U b) combiner,
  ) {
    return Computed<R>(() => combiner(value, other.value), [this, other]);
  }
}

/// Prop Extensions
extension PropExtensions<T> on Prop<T> {
  /// Increment numeric values
  void increment() {
    if (T == int) {
      value = ((value as int) + 1) as T;
    } else if (T == double) {
      value = ((value as double) + 1.0) as T;
    }
  }

  /// Decrement numeric values
  void decrement() {
    if (T == int) {
      value = ((value as int) - 1) as T;
    } else if (T == double) {
      value = ((value as double) - 1.0) as T;
    }
  }

  /// Toggle boolean values
  void toggle() {
    if (T == bool) {
      value = !(value as bool) as T;
    }
  }
}

/// List State Extensions
extension ListStateExtensions<T> on Prop<List<T>> {
  /// Add item to list
  void add(T item) {
    value = [...value, item];
  }

  /// Remove item from list
  void remove(T item) {
    value = value.where((element) => element != item).toList();
  }

  /// Clear the list
  void clear() {
    value = [];
  }

  /// Update item at index
  void updateAt(int index, T item) {
    if (index >= 0 && index < value.length) {
      final newList = [...value];
      newList[index] = item;
      value = newList;
    }
  }
}
