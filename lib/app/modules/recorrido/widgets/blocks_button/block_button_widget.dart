import 'package:flutter/material.dart';

import '../../../../../core/theme/colors_theme.dart';
import '../../../../../core/theme/text_theme.dart';
import '../../../../../core/utlis/dispose_util.dart';

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
    return SizedBox(
      width: getSize(75, sizeTablet: 130),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getSize(5), vertical: getSize(1)),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: getSize(10)),
            backgroundColor: isSelected
                ? ColorsTheme.blockSelectedColor
                : ColorsTheme.blockUnselectedColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(getSize(15)),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            block,
            style: TextStyleTheme.blockTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
