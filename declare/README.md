
---

# 📦 Declare

A lightweight Flutter package to simplify **Publish ViewModel-driven UI** with a declarative approach. It enables a clean separation of UI and logic using `ViewModel`, `Prop`, and `Declare` widget components.

---

## ✨ Features

* 🧠 Easy ViewModel management
* 🔄 Publish state updates using `Prop`
* 🧼 Clean separation of UI and business logic
* 📦 Lightweight and dependency-free (other than Flutter)

---

## 🚀 Installation

Add `declare` to your `pubspec.yaml`:

```yaml
dependencies:
  declare: ^1.2.0
```
Or

```  bash
$ flutter pub add declare
```

---

## 🛠️ Getting Started

### 1. Define a `ViewModel`

Extend the `ViewModel` class to hold your Publish values and logic.

```dart
import 'package:declare/declare.dart';

class CounterViewModel extends ViewModel with PublishRegistrable {
  final Prop<int> counter = Prop(0);

  void increment() => counter.value++;

  @override
  List<Prop> get props => [counter];

  @override
  void dispose() {
    // cleanup if needed
    super.dispose();
  }
}
```

---

### 2. Use `Declare` Widget in Your UI

Use the `Declare` widget to bind your `ViewModel` to your widget tree.

```dart
Declare<CounterViewModel>(
  create: () => CounterViewModel(),
  builder: (context, viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Count: ${viewModel.counter.value}'),
        ElevatedButton(
          onPressed: viewModel.increment,
          child: Text('Increment'),
        ),
      ],
    );
  },
);
```

---

## 📚 Core Concepts

### `Prop<T>`

A wrapper around `ValueNotifier<T>` that allows you to declare Prop fields inside your ViewModel.

```dart
final Prop<String> name = Prop('Hello');
```

### `PropRegistrable`

A mixin that allows the ViewModel to register its Prop fields so that UI can rebuild on updates.

```dart
@override
List<Prop> get props => [name, counter];
```

### `ViewModel`

An abstract class meant to be extended by your logic classes. Override `dispose()` if necessary.

---

## 📦 File Structure

| File                        | Purpose                                    |
| --------------------------- | ------------------------------------------ |
| `declare.dart`              | Exports all core functionality             |
| `view_model.dart`           | Defines `ViewModel` base class             |
| `prop.dart`                 | Defines the Prop wrapper for state     |
| `prop_registrable.dart`     | Mixin for exposing Prop fields         |
| `widgets.dart`              | Main `Declare` widget logic for binding UI |

---

## 🧪 Example

Check out the [example/](example/) directory for a full working demo.

---

## ✅ Best Practices

* Group your `Prop`s inside a ViewModel to isolate state.
* Always return Publish fields in `get props` for proper rebuilds.
* Dispose resources or subscriptions in `ViewModel.dispose`.

---

## 📄 License

MIT License © 2025 [Siva Sankar](https://github.com/siva-sankar-dev)

---
