import 'package:flutter_test/flutter_test.dart';
import 'package:declare/declare.dart';

class MyViewModel extends ViewModel {
  int counter = 0;

  void increment() {
    counter++;
    notifyListeners();
  }

  @override
  void onInit() {
    counter = 5;
  }
}

void main() {
  group('ViewModel', () {
    test('calls onInit', () {
      final vm = MyViewModel();
      vm.onInit();
      expect(vm.counter, 5);
    });

    test('notifies listeners on state change', () {
      final vm = MyViewModel();
      int notifyCount = 0;

      vm.addListener(() => notifyCount++);
      vm.increment();

      expect(vm.counter, 1);
      expect(notifyCount, 1);
    });

    test('does not notify after dispose', () {
      final vm = MyViewModel();
      int notifyCount = 0;

      vm.addListener(() => notifyCount++);
      vm.dispose();
      vm.increment(); // should not trigger notify

      expect(notifyCount, 0);
    });
  });
}
