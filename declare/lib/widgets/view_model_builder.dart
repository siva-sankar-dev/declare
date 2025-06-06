import 'package:declare/reactive/view_model.dart';
import 'package:flutter/material.dart';

class ViewModelBuilder<T extends ViewModel> extends StatefulWidget {
  final T viewModel;
  final Widget Function(BuildContext, T) builder;

  const ViewModelBuilder({
    super.key,
    required this.viewModel,
    required this.builder,
  });

  @override
  State<ViewModelBuilder<T>> createState() => _ViewModelBuilderState<T>();
}

class _ViewModelBuilderState<T extends ViewModel>
    extends State<ViewModelBuilder<T>> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.onInit();
    widget.viewModel.addListener(_onChange);
  }

  void _onChange() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onChange);
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.viewModel);
  }
}
