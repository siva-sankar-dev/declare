import 'package:flutter_test/flutter_test.dart';
import 'package:declare/declare.dart';

void main() {
  group('State<T>', () {
    test('initial value is set correctly', () {
      final counter = State<int>(5);
      expect(counter.value, 5);
    });

    test('value changes notify listeners', () {
      final counter = State<int>(0);
      int calls = 0;

      counter.addListener(() {
        calls++;
      });

      counter.value = 10;

      expect(counter.value, 10);
      expect(calls, 1);
    });

    test('does not notify if value is unchanged', () {
      final counter = State<int>(42);
      int calls = 0;

      counter.addListener(() => calls++);

      counter.value = 42;

      expect(calls, 0);
    });
  });
}