import 'package:declare/declare.dart';
import 'package:example/mvvm_example/viewmodel/color_switcher_view_model.dart';
import 'package:flutter/material.dart';

class ColorSwitcherView extends StatelessWidget {
  const ColorSwitcherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Declare(
      create: () => ColorSwitcherViewModel(),
      builder: (context, viewModel) {
        return Column(
          children: [
            Text(
              "Color Switcher",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                color: viewModel.currentColor.value.color,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      viewModel.changeColor();
                    },
                    child: Text("Change Color"),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    viewModel.currentColor.value.colorName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
