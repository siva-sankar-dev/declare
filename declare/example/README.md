# example

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
\\\Great! Here's a **complete Medium post draft** for your Flutter package **`declare`**, written in a clear, beginner-friendly, and developer-focused style.

---

# 📦 Declare – A Lightweight, ViewModel-Driven State Management for Flutter (No Dependencies!)

Hey Flutter devs! 👋

I’m excited to introduce [`declare`](https://pub.dev/packages/declare) — a minimal yet powerful **state management** package for Flutter that helps you build clean, reactive UIs with a **declarative approach**.

> With `declare`, there are no dependencies — it's 100% pure Flutter.

---

## 🚀 Why `declare`?

Most state management libraries either come with boilerplate, steep learning curves, or too many dependencies. `declare` takes a simple route:

* ViewModel + Props = 🧠 Smart and maintainable UI
* Clean separation between UI and business logic
* No streams, no complex patterns, just **Flutter**

---

## ✨ Key Features

* ✅ ViewModel-driven architecture
* 🧼 Clean separation of concerns
* 🔁 Auto UI rebuilds when props update
* ⚡ Zero external dependencies (pure Flutter)

---

## 🛠️ Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  declare: ^1.2.0
```

Or use the Flutter CLI:

```bash
flutter pub add declare
```

---

## 📚 Core Concepts

### 🔹 `Prop<T>`

A wrapper around `ValueNotifier<T>` for reactive state updates.

```dart
final Prop<int> counter = Prop(0);
```

### 🔹 `ViewModel`

An abstract base class for your logic layer.

```dart
class MyViewModel extends ViewModel with PublishRegistrable {
  final Prop<String> name = Prop('Hello');
  @override
  List<Prop> get props => [name];
}
```

### 🔹 `Declare` Widget

Wraps your widget tree and injects the ViewModel, auto-rebuilding on prop changes.

```dart
Declare<MyViewModel>(
  create: () => MyViewModel(),
  builder: (context, viewModel) {
    return Text(viewModel.name.value);
  },
);
```

---

## 🧪 Full Example — A Simple Counter App

### 1. Create a `CounterViewModel`

```dart
import 'package:declare/declare.dart';

class CounterViewModel extends ViewModel with PublishRegistrable {
  final Prop<int> counter = Prop(0);

  void increment() => counter.value++;

  @override
  List<Prop> get props => [counter];
}
```

---

### 2. Use `Declare` in Your Widget Tree

```dart
import 'package:flutter/material.dart';
import 'package:declare/declare.dart';
import 'counter_view_model.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Declare<CounterViewModel>(
      create: () => CounterViewModel(),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(title: Text('Counter')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Count: ${viewModel.counter.value}'),
                ElevatedButton(
                  onPressed: viewModel.increment,
                  child: Text('Increment'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

---

## 📁 File Structure

| File                    | Description                      |
| ----------------------- | -------------------------------- |
| `declare.dart`          | Exports all core functionality   |
| `view_model.dart`       | Abstract class for ViewModel     |
| `prop.dart`             | Defines the `Prop` wrapper       |
| `prop_registrable.dart` | Mixin to register reactive props |
| `widgets.dart`          | Home of the `Declare` widget     |

---

## ✅ Best Practices

* Group all related `Prop`s inside a single `ViewModel`.
* Always register them via `List<Prop> get props` so UI updates automatically.
* Use `dispose()` in ViewModel if you’re managing resources or subscriptions.

---

## 🔗 Useful Links

* 📦 [Declare on pub.dev](https://pub.dev/packages/declare)
* 💻 [Source code + example app](https://github.com/siva-sankar-dev/declare)

---

## 🙌 Final Thoughts

If you’re looking for a **simple, dependency-free**, and declarative state management solution for Flutter, give `declare` a try!

I’d love to hear your feedback, issues, or ideas for improvements. Contributions are welcome on GitHub!

Thanks for reading & happy coding! 💙
— [Siva Sankar](https://github.com/siva-sankar-dev)

---

Would you like me to create a cover image or diagrams for this Medium post?
