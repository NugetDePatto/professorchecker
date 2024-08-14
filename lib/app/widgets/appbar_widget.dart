import 'package:flutter/material.dart';

import '../../core/theme/colors_theme.dart';
import '../../core/theme/text_theme.dart';

class AppBarWidget extends StatelessWidget implements PreferredSize {
  final String title;
  final List<Widget>? actions;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget get child => throw UnimplementedError();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title.toUpperCase(),
        style: TextStyleTheme.titleTextStyle,
      ),
      centerTitle: true,
      backgroundColor: ColorsTheme.backgroundColor,
      iconTheme: const IconThemeData(
        color: ColorsTheme.iconColor,
        size: 30,
      ),
      toolbarHeight: 80,
      leadingWidth: 70,
      actions: actions,
    );
  }
}
