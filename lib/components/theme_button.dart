import 'package:flutter/material.dart';
import '../animations/animations.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    Key? key,
    required this.changeThemeMode,
  }) : super(key: key);

  final Function changeThemeMode;

  @override
  Widget build(BuildContext context) {
    final isBright = Theme.of(context).brightness == Brightness.light;
    return AnimatedScaleButton(
      onPressed: () => changeThemeMode(!isBright),
      child: IconButton(
        onPressed: () => changeThemeMode(!isBright),
        icon: isBright
            ? const Icon(Icons.dark_mode_outlined)
            : const Icon(Icons.light_mode_outlined),
      ),
    );
  }
}
