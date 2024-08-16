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
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: isSelected
              ? ColorsTheme.blockSelectedColor
              : ColorsTheme.blockUnselectedColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          block,
          style: TextStyleTheme.blockTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
