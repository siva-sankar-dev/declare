import 'package:declare/declare.dart';
import 'package:example/mvvm_example/model/color_model.dart';

class ColorSwitcherViewModel extends ViewModel {
  final Prop<ColorModel> currentColor = Prop(ColorModel.colors.first);
  final List<ColorModel> _colors = ColorModel.colors;
  int _currentIndex = 0;

  ColorSwitcherViewModel() {
    register(currentColor);
  }

  void changeColor() {
    _currentIndex = (_currentIndex + 1) % _colors.length;
    currentColor.value = _colors[_currentIndex];
  }
}
