import 'package:declare/declare.dart';
import 'package:declare/reactive/computed.dart';
import 'package:declare/reactive/published.dart';
import 'package:declare/reactive/view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('prop<T>', () {
    test('should notify listeners when value changes', () {
      final prop = Prop<int>(0);
      bool notified = false;

      prop.addListener(() {
        notified = true;
      });

      prop.value = 1;
      expect(prop.value, 1);
      expect(notified, true);
    });

    test('should not notify listeners if value is the same', () {
      final prop = Prop<int>(1);
      bool notified = false;

      prop.addListener(() {
        notified = true;
      });

      prop.value = 1;
      expect(notified, false);
    });
  });

  group('Published<T>', () {
    test('should notify parent on value change', () {
      final published = Published<String>();
      final parent = ChangeNotifier();
      bool parentNotified = false;

      parent.addListener(() => parentNotified = true);
      published.setParent(parent);

      published.value = "Hello";
      expect(parentNotified, true);
      expect(published.hasValue, true);
      expect(published.value, "Hello");
    });

    test('should clear value and report hasValue correctly', () {
      final published = Published<String>("Test");

      expect(published.hasValue, true);
      published.clear();
      expect(published.hasValue, false);
    });
  });

  group('Computed<T>', () {
    test('should recompute when dependency changes', () {
      final a = Prop<int>(1);
      final b = Prop<int>(2);
      final computed = Computed(() => a.value + b.value, [a, b]);

      expect(computed.value, 3);

      a.value = 3;
      expect(computed.value, 5);
    });

    test('should not update after dispose', () {
      final a = Prop<int>(1);
      final computed = Computed(() => a.value * 2, [a]);
      computed.dispose();

      a.value = 5;
      expect(computed.value, 2); // remains as-is
    });
  });

  group('ViewModel', () {
    test('should register and dispose reactive values', () {
      final viewModel = MyTestViewModel();
      viewModel.count.value = 10;
      viewModel.name.value = "Siva";

      expect(viewModel.count.value, 10);
      expect(viewModel.name.value, "Siva");

      viewModel.dispose();
      // disposing again should not crash
      viewModel.dispose();
    });

    test('should call onInit and onDispose', () {
      final vm = LifecycleViewModel();
      vm.onInit(); // manually call

      expect(vm.initCalled, true);

      vm.dispose();
      expect(vm.disposeCalled, true);
    });
  });
}

/// A dummy ViewModel for testing registration
class MyTestViewModel extends ViewModel {
  late final Prop<int> count = Prop(0);
  late final Published<String> name = published();
}

/// A dummy ViewModel for testing lifecycle hooks
class LifecycleViewModel extends ViewModel {
  bool initCalled = false;
  bool disposeCalled = false;

  @override
  void onInit() {
    initCalled = true;
  }

  @override
  void onDispose() {
    disposeCalled = true;
  }
}
