import 'package:flutter/material.dart';

import '../../../../../core/theme/colors_theme.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;
  final bool isSelected;

  const IconButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? ColorsTheme.subjectCardIcon
              : ColorsTheme.subjectCardIconSelected,
          width: 1,
        ),
        color: isSelected ? ColorsTheme.subjectCardIcon : Colors.transparent,
      ),
      child: IconButton(
        onPressed: onPressed,
        color: ColorsTheme.subjectCardIconSelected,
        iconSize: 25,
        icon: Icon(icon),
      ),
    );
  }
}
