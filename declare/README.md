
---

# 📦 Declare

**SwiftUI-inspired reactive state management for Flutter** — powered by `State<T>`, `Published<T>`, `Computed<T>`, and `ViewModel` concepts.

> Simple. Lightweight. Declarative. No external dependencies.

---

## ✨ Features

✅ Minimal, expressive syntax inspired by SwiftUI
✅ `Prop<T>` – reactive local state with automatic notification
✅ `Published<T>` – nullable reactive state that notifies parent ViewModel
✅ `Computed<T>` – derived reactive values based on dependencies
✅ `ViewModel` – lifecycle-aware logic container managing reactive states
✅ `DeclareView<T>` – widget that creates and listens to a ViewModel, rebuilding on changes
✅ `Observer<T>` – widget that listens to any `ValueListenable<T>` and rebuilds on changes
✅ Pure Dart and Flutter — no third-party dependencies
✅ Designed for clean MVVM architecture

---

## 🧱 Getting Started

Add `declare` to your `pubspec.yaml`:

```yaml
dependencies:
  declare: ^1.0.0
```

### Using `DeclareView` with a `ViewModel`

```dart
class CounterViewModel extends ViewModel {
  late final Prop<int> count;

  CounterViewModel() {
    count = Prop<int>(0);
  }

  void increment() => count.update(count.value + 1);

  @override
  void onInit() {
    print('CounterViewModel initialized');
  }

  @override
  void onDispose() {
    print('CounterViewModel disposed');
  }
}

DeclareView<CounterViewModel>(
  create: () => CounterViewModel(),
  builder: (context, vm) {
    return Column(
      children: [
        Observer<int>(
          observable: vm.count,
          builder: (context, value) => Text('Count: $value'),
        ),
        ElevatedButton(
          onPressed: vm.increment,
          child: Text('Increment'),
        ),
      ],
    );
  },
);
```

### Reacting to any `ValueListenable<T>` with `Observer`

```dart
Observer<int>(
  observable: someValueListenable,
  builder: (context, value) => Text('Value: $value'),
);
```

---

## 📚 API Overview

* `Prop<T>` – a reactive wrapper around a value with update and transform methods. Notifies listeners on changes.
* `Published<T>` – nullable reactive state, notifies its parent `ViewModel` when changed.
* `Computed<T>` – a derived reactive value computed from one or more dependencies (`ValueListenable`s).
* `ViewModel` – base class managing multiple reactive states and computed values, with lifecycle hooks `onInit()` and `onDispose()`.
* `DeclareView<T extends ViewModel>` – Flutter widget that instantiates a ViewModel, calls its lifecycle, and rebuilds on change.
* `Observer<T>` – widget that listens to any `ValueListenable<T>` and rebuilds when the value changes.

---

## ⚙️ Lifecycle

* `ViewModel.onInit()` is called once when `DeclareView` initializes.
* `ViewModel.onDispose()` is called when `DeclareView` disposes.
* Reactive states notify their parent ViewModel, which triggers widget rebuilds.

---

## 🛠️ Advantages

* Familiar MVVM pattern with reactive data binding
* No extra dependencies, pure Flutter code
* Clear separation of UI and business logic
* Easy to test ViewModels without Flutter widgets

---
