// ------------------------------------------------------------ //
//  main.dart
//
//  A simple example demonstrating a custom reactive state management
//  system using [Prop], [ViewModel], and [Declare].
//
//  Created by Siva Sankar on 2025-06-07.
// ------------------------------------------------------------ //

import 'package:declare/declare.dart';
import 'package:example/mvvm_example/view/color_switcher_view.dart';
import 'package:flutter/material.dart';

/// Entry point of the Flutter application.
///
/// This initializes and runs the [CounterExampleApp].
void main() {
  runApp(const ExampleApp());
}

// ------------------------------------------------------------ //
// ViewModel
// ------------------------------------------------------------ //

/// A [ViewModel] that manages the state for a simple counter example.
///
/// This class uses a [Prop] to hold and notify changes to the counter value.
/// It implements [PropRegistrable] to expose all reactive properties to the
/// [Declare] widget so the UI can rebuild automatically on updates.
class ExampleViewModel extends ViewModel {
  final Prop<Examples> currentExample = Prop(Examples.mvvm);

  ExampleViewModel() {
    register(currentExample);
  }

  void changeExample(Examples to) {
    currentExample.value = to;
  }
}

enum Examples { mvvm }

// ------------------------------------------------------------ //
// UI (View)
// ------------------------------------------------------------ //

/// The root widget of the application.
///
/// Uses the [Declare] widget to bind the [CounterExampleViewModel] to the UI.
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Declare(
        // Creates an instance of the ViewModel
        create: () => ExampleViewModel(),

        // Rebuilds the UI whenever the observed Props change
        builder: (context, viewModel) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Declare Counter"),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Button to increment the count value
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          viewModel.changeExample(Examples.mvvm);
                        },
                        child: const Text("MVVM Example"),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  exmpleView(context, viewModel.currentExample.value),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget exmpleView(BuildContext context, Examples example) {
    switch (example) {
      case Examples.mvvm:
        return ColorSwitcherView();
    }
  }
}
