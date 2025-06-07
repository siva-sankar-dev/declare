// ------------------------------------------------------------ //
//  widgets.dart
//
//  Created by Siva Sankar on 2025-06-07.
// ------------------------------------------------------------ //

import 'package:declare/prop_registrable.dart';
import 'package:declare/prop.dart';
import 'package:declare/view_model.dart';
import 'package:flutter/material.dart';

/// A builder function to construct UI using the ViewModel.
typedef ViewModelBuilder<T extends ViewModel> =
    Widget Function(BuildContext context, T viewModel);

/// A widget that binds a [ViewModel] and rebuilds UI on Publish changes.
class Declare<T extends ViewModel> extends StatefulWidget {
  final T Function() create;
  final ViewModelBuilder<T> builder;

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
  }

  void _collectPublishFields() {
    if (_viewModel is PropRegistrable) {
      _prop.addAll(((_viewModel as PropRegistrable).props));
      for (var p in _prop) {
        p.addListener(_onChange);
      }
    }
  }

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
