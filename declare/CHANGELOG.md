## 0.0.1

- Initial release of `declare`.

## [1.3.0 - Stable] - 2025-06-08 

### Added
- Added `onInit()` lifecycle method to `ViewModel` for initialization logic.
- Introduced `register()` method in `ViewModel` to simplify `Prop` registration.
- Automatically collects `Prop`s without needing to override `get props`.

### Changed
- Updated `Declare` widget to call `onInit()` during `initState()`.

### Improved
- ViewModel structure is now cleaner and less boilerplate.
- Greatly improved ergonomics for creating and managing reactive ViewModels.

### Example Migration

```dart
class CounterViewModel extends ViewModel {
  final counter = Prop(0);

  CounterViewModel() {
    register(counter); // No need to override props manually
  }

  @override
  void onInit() {
    print('Initialized');
  }

  void increment() => counter.value++;
}
```