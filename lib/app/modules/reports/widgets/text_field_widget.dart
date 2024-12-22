import 'package:flutter/material.dart';

import '../../../../core/theme/colors_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  const CustomTextField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      minLines: 1,
      expands: false,
      obscureText: false,
      cursorColor: ColorsTheme.textFieldColor,
      style: const TextStyle(color: ColorsTheme.textFieldTextColor),
      decoration: InputDecoration(
        hintText: 'Escribe algo aquí',
        hintStyle: const TextStyle(color: ColorsTheme.textFieldTextColor),
        contentPadding: const EdgeInsets.all(20),
        filled: true,
        fillColor: ColorsTheme.texFieldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: ColorsTheme.textFieldColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: ColorsTheme.textFieldColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: ColorsTheme.textFieldColor,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
