// ------------------------------------------------------------ //
//  view_model.dart
//
//  Created by Siva Sankar on 2025-06-07.
// ------------------------------------------------------------ //

import 'package:declare/prop_registrable.dart';
import 'prop.dart';

/// A base class for view models. Can be extended to hold state and dispose resources.
abstract class ViewModel with PropRegistrable {
  final List<Prop> _registeredProps = [];

  /// Automatically register a [Prop] so it can notify the UI on change.
  T register<T>(T prop) {
    if (prop is Prop) {
      _registeredProps.add(prop);
    }
    return prop;
  }

  /// Return all registered props for reactive updates.
  @override
  List<Prop> get props => _registeredProps;

  /// Optional lifecycle method to perform initialization logic.
  void onInit() {}

  /// Called when the ViewModel is being disposed.
  void dispose() {}
}
