// ------------------------------------------------------------ //
//  observer.dart
//
//  Created by Siva Sankar on 2025-06-06.
// ------------------------------------------------------------ //

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// A widget that rebuilds itself whenever the given [ValueListenable] changes.
///
/// Use [Observer] to reactively update only specific parts of your widget tree
/// based on state changes.
///
/// It listens to a `State`, `Published`, or `Computed` object and
/// rebuilds the UI when the underlying value changes.
///
/// Example:
/// ```dart
/// Observer<int>(
///   observable: viewModel.count,
///   builder: (context, value) => Text('Count: $value'),
/// );
/// ```
class Observer<T> extends StatefulWidget {
  /// The reactive [ValueListenable] to observe.
  final ValueListenable<T> observable;

  /// A builder that receives the latest value and returns a widget.
  final Widget Function(BuildContext context, T value) builder;

  /// Creates an [Observer] that listens to changes from [observable]
  /// and rebuilds the widget using [builder].
  const Observer({
    super.key,
    required this.observable,
    required this.builder,
  });

  @override
  State<Observer<T>> createState() => _ObserverState<T>();
}

class _ObserverState<T> extends State<Observer<T>> {
  @override
  void initState() {
    super.initState();
    widget.observable.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(Observer<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reattach listener if observable instance changes
    if (oldWidget.observable != widget.observable) {
      oldWidget.observable.removeListener(_rebuild);
      widget.observable.addListener(_rebuild);
    }
  }

  /// Called when the observed value changes.
  /// Triggers a rebuild if the widget is still mounted.
  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.observable.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.observable.value);
  }
}
