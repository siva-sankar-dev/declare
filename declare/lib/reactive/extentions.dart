// ------------------------------------------------------------ //
//  extentions.dart
//
//  Created by Siva Sankar on 2025-06-06.
// ------------------------------------------------------------ //

import 'package:declare/reactive/computed.dart';
import 'package:declare/reactive/prop.dart';
import 'package:flutter/foundation.dart';

// ------------------------------------------------------------ //
// Reactive Extentions
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

// ------------------------------------------------------------ //
// Prop Extentions
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

// ------------------------------------------------------------ //
// List State Extentions
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
