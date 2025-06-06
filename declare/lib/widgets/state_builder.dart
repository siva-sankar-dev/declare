import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StateBuilder<T> extends StatelessWidget {
  final ValueListenable<T> state;
  final Widget Function(BuildContext, T) builder;
  const StateBuilder({super.key, required this.state, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: state,
      builder: (context, value, child) => builder(context, value),
    );
  }
}
