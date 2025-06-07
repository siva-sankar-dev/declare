# 📦 Declare
**SwiftUI-inspired reactive state management for Flutter** — powered by `Prop<T>`, `Published<T>`, `Computed<T>`, and `ViewModel` concepts.

> Simple. Lightweight. Declarative. No external dependencies. **Auto-reactive** — no more Observer widgets needed!

---

## ✨ Features

✅ **Auto-reactive UI** — access `viewModel.count.value` directly, rebuilds automatically  
✅ **Minimal syntax** inspired by SwiftUI and modern reactive frameworks  
✅ `Prop<T>` – reactive local state with automatic notification  
✅ `Published<T>` – nullable reactive state that notifies parent ViewModel  
✅ `Computed<T>` – derived reactive values based on dependencies  
✅ `ViewModel` – lifecycle-aware logic container managing reactive states  
✅ `Declare<T>` – widget with automatic dependency tracking and rebuilding  
✅ **Pure Dart and Flutter** — no third-party dependencies  
✅ **Clean MVVM architecture** with excellent developer experience  

---

## 🚀 What's New in Auto-Reactive Mode


```dart
// ✅ New way - Auto-reactive!
Text('Count: ${viewModel.count.value}') // Rebuilds automatically!
```

---

## 🧱 Getting Started

Add `declare` to your `pubspec.yaml`:

```yaml
dependencies:
  declare: ^1.0.0
```

### Basic Example - Auto-Reactive Counter

```dart
class CounterViewModel extends ViewModel {
  late final count = state(0);
  late final doubleCount = computed(() => count.value * 2, [count]);
  late final message = state('Hello World');
  
  void increment() => count.value++;
  void decrement() => count.value--;
  void updateMessage(String newMessage) => message.value = newMessage;
  
  @override
  void onInit() {
    print('CounterViewModel initialized');
  }
  
  @override
  void onDispose() {
    print('CounterViewModel disposed');
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Declare<CounterViewModel>(
      create: () => CounterViewModel(),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(title: Text('Auto-Reactive Counter')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // These automatically rebuild when values change! 🎉
                Text('Count: ${viewModel.count.value}'),
                Text('Double: ${viewModel.doubleCount.value}'),
                Text('Message: ${viewModel.message.value}'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: viewModel.decrement,
                      child: Text('-'),
                    ),
                    ElevatedButton(
                      onPressed: viewModel.increment,
                      child: Text('+'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => viewModel.updateMessage('Updated!'),
                  child: Text('Update Message'),
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

### Advanced Example - Shopping Cart

```dart
class Product {
  final String name;
  final double price;
  Product(this.name, this.price);
}

class CartViewModel extends ViewModel {
  late final items = state<List<Product>>([]);
  late final total = computed(() => 
    items.value.fold(0.0, (sum, item) => sum + item.price), 
    [items]
  );
  late final itemCount = computed(() => items.value.length, [items]);
  
  void addItem(Product product) {
    items.value = [...items.value, product];
  }
  
  void removeItem(Product product) {
    items.value = items.value.where((item) => item != product).toList();
  }
  
  void clearCart() {
    items.value = [];
  }
}

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Declare<CartViewModel>(
      create: () => CartViewModel(),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Cart (${viewModel.itemCount.value})'),
          ),
          body: Column(
            children: [
              Text('Total: \$${viewModel.total.value.toStringAsFixed(2)}'),
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.items.value.length,
                  itemBuilder: (context, index) {
                    final item = viewModel.items.value[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('\$${item.price}'),
                      trailing: IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => viewModel.removeItem(item),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

---

## 📚 API Overview

### Core Classes

**`Prop<T>`** – Reactive wrapper around a value with update and transform methods
```dart
final count = Prop<int>(0);
count.value = 5; // Automatically notifies listeners
count.increment(); // Built-in helper for numbers
count.transform((current) => current * 2); // Transform current value
```

**`Published<T>`** – Nullable reactive state that notifies parent ViewModel
```dart
final user = Published<User>(); // Starts as null
user.value = User('John');
user.clear(); // Set back to null
print(user.hasValue); // Check if value exists
```

**`Computed<T>`** – Derived reactive value computed from dependencies
```dart
final fullName = computed(() => '${firstName.value} ${lastName.value}', [firstName, lastName]);
// Automatically updates when firstName or lastName changes
```

**`ViewModel`** – Base class managing reactive states with lifecycle hooks
```dart
class MyViewModel extends ViewModel {
  late final count = state(0); // Creates Prop<int>
  late final user = published<User>(); // Creates Published<User>
  late final doubleCount = computed(() => count.value * 2, [count]);
  
  @override
  void onInit() { /* Called when ViewModel is created */ }
  
  @override
  void onDispose() { /* Called when ViewModel is disposed */ }
}
```

**`Declare<T>`** – Widget that creates and manages ViewModel lifecycle
```dart
Declare<MyViewModel>(
  create: () => MyViewModel(),
  builder: (context, viewModel) {
    return Text('Count: ${viewModel.count.value}'); // Auto-reactive!
  },
);
```

### Extensions

**Reactive Extensions** – Chain operations on any `ValueListenable<T>`
```dart
final doubled = count.map((value) => value * 2);
final combined = count.combine(name, (c, n) => '$n: $c');
```

**Prop Extensions** – Convenient methods for common operations
```dart
count.increment(); // For numbers
count.decrement(); // For numbers
isVisible.toggle(); // For booleans
```

**List Extensions** – Easy list manipulation
```dart
final items = state<List<String>>([]);
items.add('New item');
items.remove('Old item');
items.clear();
items.updateAt(0, 'Updated item');
```

---

## 🔄 How Auto-Reactivity Works

1. **Dependency Tracking**: When you access `viewModel.count.value` during a build, Declare automatically tracks this dependency
2. **Change Detection**: When `count.value` changes, all widgets that accessed it are marked for rebuild
3. **Efficient Updates**: Only the specific `Declare` widgets that depend on changed values are rebuilt
4. **No Manual Subscriptions**: No need to wrap values in `Observer` widgets or manually manage listeners

---

## ⚙️ Lifecycle

* `ViewModel.onInit()` is called once when `Declare` initializes
* `ViewModel.onDispose()` is called when `Declare` disposes
* Reactive states automatically notify their parent ViewModel
* **Auto-tracking** subscribes to accessed values during build phase
* All reactive resources are automatically cleaned up on disposal

---

## 🎯 Best Practices

### ✅ Do
```dart
// Use direct value access in Declare
Text('Count: ${viewModel.count.value}')

// Create computed values for derived state
late final total = computed(() => items.value.fold(0, (a, b) => a + b.price), [items]);

// Use lifecycle hooks for initialization
@override
void onInit() {
  loadUserData();
}
```

### ❌ Don't
```dart

// Don't forget to use .value when accessing
Text('Count: ${viewModel.count}') // Missing .value!

// Don't mutate state directly in build method
Text('Count: ${viewModel.count.value++}') // Side effect in build!
```

---

## 🚀 Performance Benefits

* **Granular Updates**: Only widgets that access changed values rebuild
* **Automatic Optimization**: No need to manually optimize with `Consumer` or `Selector` patterns
* **Minimal Overhead**: Dependency tracking adds negligible performance cost
* **Memory Efficient**: Automatic cleanup prevents memory leaks

---

## 🧪 Testing

ViewModels are easy to test since they're pure Dart classes:

```dart
void main() {
  group('CounterViewModel', () {
    late CounterViewModel viewModel;
    
    setUp(() {
      viewModel = CounterViewModel();
    });
    
    tearDown(() {
      viewModel.dispose();
    });
    
    test('should increment count', () {
      expect(viewModel.count.value, 0);
      viewModel.increment();
      expect(viewModel.count.value, 1);
    });
    
    test('should compute double count', () {
      viewModel.count.value = 5;
      expect(viewModel.doubleCount.value, 10);
    });
  });
}
```

---

## 🎨 Comparison with Other Solutions

| Feature | Declare | Provider | Riverpod | Bloc |
|---------|---------|----------|----------|------|
| Auto-reactive | ✅ | ❌ | ❌ | ❌ |
| Boilerplate | Minimal | Medium | Low | High |
| Learning Curve | Easy | Easy | Medium | Hard |
| Performance | Excellent | Good | Excellent | Excellent |
| Testing | Easy | Medium | Easy | Easy |
| DevTools | Basic | Excellent | Excellent | Excellent |

---

## 🔮 Roadmap

- [ ] DevTools integration for state inspection
- [ ] Async state management utilities
- [ ] State persistence helpers
- [ ] Time-travel debugging
- [ ] React DevTools-style state inspector

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📄 License

This project is licensed under the MIT License.

---

**Made with ❤️ for the Flutter community**

*Declare: Where reactive meets declarative* 🚀