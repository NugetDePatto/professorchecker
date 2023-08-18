import 'package:checadordeprofesores/controllers/rerecorrido_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive_utils.dart';
import '../../widgets/app_bar.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  RecorridoControlador c = RecorridoControlador();
  // List<String> diasSemana = [
  //   'Lunes',
  //   'Martes',
  //   'Miercoles',
  //   'Jueves',
  //   'Viernes',
  //   'Sabado',
  //   'Domingo'
  // ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool d = dis(context);
    return Scaffold(
      appBar: getAppBar('Agenda de Profesores', context),
      body: StreamBuilder(
        stream: c.stremFire,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasData) {
            return FutureBuilder(
              future: c.obtener(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> profesores =
                      snapshot.data ?? [];
                  return ListView(
                    children: [
                      for (var profesor in profesores)
                        ListTile(
                          title: Text(profesor.data()['nombre']),
                          subtitle: Text(profesor.data()['id']),
                          onTap: () {
                            Navigator.pushNamed(context, '/info_prof',
                                arguments: profesor.data());
                          },
                        )
                    ],
                  );
                }
              },
            );
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
