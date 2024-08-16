import 'package:flutter/material.dart';

import '../../../../../core/theme/colors_theme.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;
  final bool isSelected;

  final Color color;

  const IconButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.isSelected,
    this.color = ColorsTheme.subjectCardIconUnselected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.transparent,
          width: 1,
        ),
        color: isSelected ? ColorsTheme.subjectCardIconSelected : color,
      ),
      child: IconButton(
        onPressed: onPressed,
        color: ColorsTheme.subjectCardIcon,
        iconSize: 25,
        icon: Icon(icon),
      ),
    );
  }
}
