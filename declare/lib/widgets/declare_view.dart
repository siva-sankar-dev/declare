// ------------------------------------------------------------ //
//  declare_view.dart
//
//  Created by Siva Sankar on 2025-06-06.
// ------------------------------------------------------------ //

import 'package:declare/reactive/view_model.dart';
import 'package:flutter/material.dart';

/// A widget that manages the lifecycle of a [ViewModel] and rebuilds the UI
/// when the ViewModel notifies changes.
///
/// This is the entry point for using the reactive state management system.
/// It handles:
/// - Creating the ViewModel instance
/// - Invoking `onInit()` when the widget is inserted into the widget tree
/// - Automatically calling `dispose()` when removed
/// - Listening to the ViewModel’s notifications and triggering `setState()`
///
/// Example usage:
/// ```dart
/// DeclareView<MyViewModel>(
///   create: () => MyViewModel(),
///   builder: (context, viewModel) {
///     return Text(viewModel.title.value);
///   },
/// );
/// ```
class DeclareView<T extends ViewModel> extends StatefulWidget {
  /// A factory function that creates a new instance of [ViewModel].
  ///
  /// This function is called only once when the widget is inserted into the widget tree.
  final T Function() create;

  /// A builder function that provides the [BuildContext] and the created [ViewModel]
  /// for building the UI.
  final Widget Function(BuildContext context, T viewModel) builder;

  /// Creates a [DeclareView] with the given [create] and [builder] functions.
  const DeclareView({
    super.key,
    required this.create,
    required this.builder,
  });

  @override
  State<DeclareView<T>> createState() => _DeclareViewState<T>();
}

class _DeclareViewState<T extends ViewModel> extends State<DeclareView<T>> {
  /// Holds the instance of the created ViewModel.
  late final T _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.create();
    _viewModel.onInit(); // Lifecycle hook
    _viewModel.addListener(_rebuild); // Rebuild on notifyListeners
  }

  /// Called when the ViewModel emits changes.
  /// Triggers a rebuild of the widget.
  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_rebuild);
    _viewModel.dispose(); // Clean up ViewModel and reactive resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _viewModel);
  }
}
