// ------------------------------------------------------------ //
//  widgets.dart
//
//  Created by Siva Sankar on 2025-06-07.
// ------------------------------------------------------------ //

import 'package:declare/prop_registrable.dart';
import 'package:declare/prop.dart';
import 'package:declare/view_model.dart';
import 'package:flutter/material.dart';

/// A builder function that provides the [BuildContext] and an instance of [ViewModel]
/// to build a reactive widget.
typedef ViewModelBuilder<T extends ViewModel> =
    Widget Function(BuildContext context, T viewModel);

/// A widget that binds a [ViewModel] to the widget tree and rebuilds the UI
/// whenever any registered [Prop] within the ViewModel changes.
///
/// This enables a clean separation between business logic (ViewModel) and
/// presentation (UI) using a declarative reactive approach.
class Declare<T extends ViewModel> extends StatefulWidget {
  /// Factory method to create the ViewModel instance.
  final T Function() create;

  /// Builder function that provides the ViewModel to the widget tree.
  final ViewModelBuilder<T> builder;

  /// Creates a [Declare] widget that manages the lifecycle of the ViewModel and
  /// listens to any changes in its registered [Prop] fields.
  ///
  /// Example:
  /// ```dart
  /// Declare<CounterViewModel>(
  ///   create: () => CounterViewModel(),
  ///   builder: (context, viewModel) {
  ///     return Text('Count: ${viewModel.counter.value}');
  ///   },
  /// );
  /// ```
  const Declare({super.key, required this.create, required this.builder});

  @override
  State<Declare<T>> createState() => _DeclareState<T>();
}

class _DeclareState<T extends ViewModel> extends State<Declare<T>> {
  late T _viewModel;
  final List<Prop> _prop = [];

  @override
  void initState() {
    super.initState();
    _viewModel = widget.create();
    _collectPublishFields();
    _viewModel.onInit();
  }

  /// Collects all [Prop] fields from the ViewModel and attaches listeners to them
  /// to trigger widget rebuilds on value changes.
  void _collectPublishFields() {
    _prop.addAll(((_viewModel as PropRegistrable).props));
    for (var p in _prop) {
      p.addListener(_onChange);
    }
  }

  /// Triggers a widget rebuild when any of the registered [Prop]s change.
  void _onChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (var r in _prop) {
      r.removeListener(_onChange);
    }
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _viewModel);
  }
}
