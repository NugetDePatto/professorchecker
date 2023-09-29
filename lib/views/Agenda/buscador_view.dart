import 'package:checadordeprofesores/controllers/rerecorrido_controller.dart';
import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class BuscadorView extends StatefulWidget {
  const BuscadorView({super.key});

  @override
  State<BuscadorView> createState() => _BuscadorViewState();
}

class _BuscadorViewState extends State<BuscadorView> {
  RecorridoControlador c = RecorridoControlador();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Buscar', context),
      body: const Center(
        child: Text('Buscador'),
      ),
    );
  }
}
