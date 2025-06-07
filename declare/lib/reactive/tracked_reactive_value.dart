// ------------------------------------------------------------ //
//  tracked_reactive_value
//
//  Created by Siva Sankar on 2025-06-07.
// ------------------------------------------------------------ //

import 'package:declare/reactive/reactive_context.dart';
import 'package:flutter/foundation.dart';

/// A mixin that adds automatic tracking capabilities to reactive values
/// This mixin requires the implementing class to provide _getRawValue()
mixin TrackedValueMixin<T> on ValueListenable<T> {
  /// Subclasses must implement this to return the actual value
  T _getRawValue();
  
  @override
  T get value {
    // Track access in the current reactive context
    ReactiveContext.current?.trackAccess(this);
    return _getRawValue();
  }
}
