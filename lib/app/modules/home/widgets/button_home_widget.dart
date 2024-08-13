import 'package:flutter/material.dart';

import '../../../../core/theme/colors_theme.dart';
import '../../../../core/theme/text_theme.dart';

class ButtonHomeWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onPressed;

  const ButtonHomeWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 20,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsTheme.buttonBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: ColorsTheme.buttonTextColor,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  text,
                  style: TextStyleTheme.buttonTextStyle,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
