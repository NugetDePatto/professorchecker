import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class VerSalon extends StatelessWidget {
  const VerSalon({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    String salon = args['salon'];

    return Scaffold(
      appBar: getAppBar('VerSalon', context),
      body: Center(
        child: Text('VerSalon: $salon'),
      ),
    );
  }
}
