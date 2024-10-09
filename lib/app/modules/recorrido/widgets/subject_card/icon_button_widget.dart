import 'package:flutter/material.dart';

import '../../../../../core/theme/colors_theme.dart';
import '../../../../../core/utlis/dispose_util.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;
  final bool? isSelected;

  final Color color;

  const IconButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isSelected,
    this.color = ColorsTheme.subjectCardIconUnselected,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:

            // ColorsTheme.subjectCardIconSelected : color,
            isSelected == null
                ? color
                : isSelected!
                    ? ColorsTheme.subjectCardIconSelected
                    : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getSize(20)),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: getSize(15),
          vertical: getSize(5),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: getSize(0, sizeTablet: 10),
          vertical: getSize(5),
        ),
        child: Icon(
          icon,
          size: getSize(25),
          color: ColorsTheme.subjectCardIcon,
        ),
      ),
    );
  }
}
