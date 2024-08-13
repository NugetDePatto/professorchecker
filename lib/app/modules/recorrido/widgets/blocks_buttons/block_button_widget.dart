import 'package:flutter/material.dart';

import '../../../../../core/theme/colors_theme.dart';
import '../../../../../core/theme/text_theme.dart';

class BlockButtonWidget extends StatelessWidget {
  final String block;
  final Function() onPressed;
  final bool isSelected;
  const BlockButtonWidget({
    super.key,
    required this.block,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: ColorsTheme.buttonBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(
              width: 3,
              color: isSelected
                  ? ColorsTheme.buttonSelectedColor
                  : Colors.transparent,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          block,
          style: TextStyleTheme.buttonTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
