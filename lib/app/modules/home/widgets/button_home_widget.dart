import 'package:checadordeprofesores/core/utlis/dispose_util.dart';
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getSize(20)),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: getSize(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: getSize(10)),
              width: getSize(65),
              decoration: BoxDecoration(
                color: ColorsTheme.homeButtonIcon,
                borderRadius: BorderRadius.all(Radius.circular(getSize(15))),
              ),
              child: Icon(
                icon,
                size: getSize(30),
                color: ColorsTheme.lightColor,
              ),
            ),
            SizedBox(width: getSize(20)),
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
    );
  }
}
