// ------------------------------------------------------------ //
//  prop.dart
//
//  Created by Siva Sankar on 2025-06-07.
// ------------------------------------------------------------ //

import 'package:flutter/foundation.dart';

/// A Property wrapper around [ValueNotifier] to notify UI on value change.
class Prop<T> extends ValueNotifier<T> {
  Prop(super.value);
}
