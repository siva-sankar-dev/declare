// ------------------------------------------------------------ //
//  declare.dart
//
//  Created by Siva Sankar on 2025-06-06.
// ------------------------------------------------------------ //
library;


import 'package:flutter/material.dart';
import 'reactive.dart';
import 'view_model.dart';

// Export all public APIs
export 'reactive.dart';
export 'view_model.dart';

/// A widget that manages the lifecycle of a [ViewModel] and automatically
/// tracks reactive value access to rebuild the UI when needed.
///
/// Example usage:
/// ```dart
/// Declare<CounterViewModel>(
///   create: () => CounterViewModel(),
///   builder: (context, viewModel) {
///     return Text('Count: ${viewModel.count.value}'); // Auto-reactive!
///   },
/// );
/// ```
class Declare<T extends ViewModel> extends StatefulWidget {
  /// A factory function that creates a new instance of [ViewModel].
  final T Function() create;

  /// A builder function that provides the [BuildContext] and the created [ViewModel]
  /// for building the UI.
  final Widget Function(BuildContext context, T viewModel) builder;

  /// Creates a [Declare] with the given [create] and [builder] functions.
  const Declare({super.key, required this.create, required this.builder});

  @override
  State<Declare<T>> createState() => _DeclareState<T>();
}

class _DeclareState<T extends ViewModel> extends State<Declare<T>> {
  /// Holds the instance of the created ViewModel.
  late final T _viewModel;

  /// Reactive context for tracking value access
  late final ReactiveContext _reactiveContext;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.create();
    _reactiveContext = ReactiveContext();
    _reactiveContext.addChangeCallback(_rebuild);
    _viewModel.onInit(); // Lifecycle hook
  }

  /// Called when any tracked reactive value changes.
  /// Triggers a rebuild of the widget.
  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _reactiveContext.dispose();
    _viewModel.dispose(); // Clean up ViewModel and reactive resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Run the builder within the reactive context to track value access
    return ReactiveContext.runInContext(
      _reactiveContext,
      () => widget.builder(context, _viewModel),
    );
  }
}