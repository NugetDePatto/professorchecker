import 'package:checadordeprofesores/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget getAppBar(
  String title,
  BuildContext context, {
  List<Widget>? actions,
  bool? leading,
}) {
  bool d = dis(context);
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    centerTitle: true,
    toolbarHeight: d ? 100 : 70,
    titleTextStyle: TextStyle(
      fontSize: d ? 40 : 20,
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(
      size: d ? 50 : 30,
    ),
    leadingWidth: d ? 80 : 70,
    actions: actions,
    leading: leading != null
        ? IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    '¿Quiere salir a la pantalla de inicio?',
                    textAlign: TextAlign.center,
                  ),
                  actionsAlignment: MainAxisAlignment.spaceEvenly,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Salir'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.arrow_back),
          )
        : null,
  );
}
