import 'package:flutter_test/flutter_test.dart';
import 'package:declare/declare.dart';

void main() {
  group('Published<T>', () {
    test('initial value is nullable and settable', () {
      final text = Published<String?>();
      expect(text.value, null);

      text.value = 'Hello';
      expect(text.value, 'Hello');
    });

    test('value change notifies listeners', () {
      final name = Published<String>('John');
      int notifyCount = 0;

      name.addListener(() => notifyCount++);

      name.value = 'Jane';
      expect(name.value, 'Jane');
      expect(notifyCount, 1);
    });

    test('no notify on same value', () {
      final flag = Published<bool>(true);
      int notifyCount = 0;

      flag.addListener(() => notifyCount++);
      flag.value = true;

      expect(notifyCount, 0);
    });
  });
}
