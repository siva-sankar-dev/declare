// ------------------------------------------------------------ //
//  main.dart
//
//  A simple example demonstrating a custom reactive state management
//  system using [Prop], [ViewModel], and [Declare].
//
//  Created by Siva Sankar on 2025-06-07.
// ------------------------------------------------------------ //


import 'package:declare/declare.dart';
import 'package:flutter/material.dart';

/// Entry point of the Flutter application.
///
/// This initializes and runs the [CounterExampleApp].
void main() {
  runApp(const CounterExampleApp());
}

// ------------------------------------------------------------ //
// ViewModel
// ------------------------------------------------------------ //

/// A [ViewModel] that manages the state for a simple counter example.
///
/// This class uses a [Prop] to hold and notify changes to the counter value.
/// It implements [PropRegistrable] to expose all reactive properties to the
/// [Declare] widget so the UI can rebuild automatically on updates.
class CounterExampleViewModel extends ViewModel with PropRegistrable {
  /// A reactive property that holds the current count value.
  ///
  /// Any change to this value will notify listeners (like the UI).
  final Prop<int> count = Prop(0);

  /// A list of all reactive [Prop]s used in this view model.
  ///
  /// Required by [PropRegistrable] to automatically register listeners.
  @override
  List<Prop> get props => [count];

  /// Increments the [count] by 1.
  ///
  /// This triggers a UI rebuild if [count] is being observed.
  void incrementCount() => count.value++;
}

// ------------------------------------------------------------ //
// UI (View)
// ------------------------------------------------------------ //

/// The root widget of the application.
///
/// Uses the [Declare] widget to bind the [CounterExampleViewModel] to the UI.
class CounterExampleApp extends StatelessWidget {
  const CounterExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Declare(
        // Creates an instance of the ViewModel
        create: () => CounterExampleViewModel(),

        // Rebuilds the UI whenever the observed Props change
        builder: (context, viewModel) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Declare Counter"),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Displays the current count value
                  Text(
                    "Count: ${viewModel.count.value}",
                    style: const TextStyle(fontSize: 24),
                  ),

                  const SizedBox(height: 16),

                  // Button to increment the count value
                  ElevatedButton(
                    onPressed: viewModel.incrementCount,
                    child: const Text("Increment Value"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
