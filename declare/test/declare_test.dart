// ------------------------------------------------------------ //
//  declare_test.dart
//
//  Created by Siva Sankar on 2025-06-07.
// ------------------------------------------------------------ //
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:declare/widgets.dart';
import 'package:declare/prop.dart';
import 'package:declare/prop_registrable.dart';
import 'package:declare/view_model.dart';

class TestViewModel extends ViewModel with PropRegistrable {
  final Prop<int> counter = Prop(0);

  @override
  List<Prop> get props => [counter];

  void increment() => counter.value++;
}

void main() {
  testWidgets('Declare widget rebuilds when Prop changes', (tester) async {
    late TestViewModel capturedViewModel;

    await tester.pumpWidget(
      MaterialApp(
        home: Declare<TestViewModel>(
          create: () => TestViewModel(),
          builder: (context, viewModel) {
            capturedViewModel = viewModel;
            return Text(
              '${viewModel.counter.value}',
              textDirection: TextDirection.ltr,
            );
          },
        ),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    capturedViewModel.increment();
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });

  test('Prop notifies listeners on value change', () {
    final prop = Prop<int>(10);
    int updates = 0;
    prop.addListener(() => updates++);
    prop.value = 20;

    expect(updates, 1);
  });

  test('PropRegistrable exposes props correctly', () {
    final viewModel = TestViewModel();
    expect(viewModel.props.length, 1);
    expect(viewModel.props.first, viewModel.counter);
  });
}
