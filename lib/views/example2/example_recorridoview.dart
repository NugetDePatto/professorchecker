import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class ExampleRecorrido extends StatefulWidget {
  const ExampleRecorrido({super.key});

  @override
  State<ExampleRecorrido> createState() => _ExampleRecorridoState();
}

class _ExampleRecorridoState extends State<ExampleRecorrido> {
  // ModalRoute.of(context)!.settings.arguments as NewRecorridoController;
  // NewRecorridoController? controller;
  @override
  void initState() {
    super.initState();
    // var x = ModalRoute.of(context)!.settings.arguments;

    // print(controller!.recorrido);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Recorrido', [], context),
    );
  }
}
