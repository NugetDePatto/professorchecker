import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../controllers/rerecorrido_controller.dart';
import '../../utils/date_utils.dart';

class ExampleRecorrido extends StatefulWidget {
  const ExampleRecorrido({super.key});

  @override
  State<ExampleRecorrido> createState() => _ExampleRecorridoState();
}

class _ExampleRecorridoState extends State<ExampleRecorrido> {
  RecorridoControlador c = RecorridoControlador();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller = ModalRoute.of(context)!.settings.arguments
    //       as NewRecorridoController; // Obtener el controlador
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Recorrido $horarioActual', context),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref().onChildChanged,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return c.listaUsers();
          } else if (snapshot.hasData) {
            return c.listaUsers();
          } else if (snapshot.hasError) {
            return const Text('Error al obtener los datos');
          } else {
            return const Text('No hay datos');
          }
        },
      ),
    );
  }
}
