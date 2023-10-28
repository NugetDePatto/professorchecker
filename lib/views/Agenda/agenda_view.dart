import 'package:checadordeprofesores/controllers/rerecorrido_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_bar.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  RecorridoControlador c = RecorridoControlador();
  TextEditingController t = TextEditingController();

  List<QueryDocumentSnapshot<Map<String, dynamic>>> coincidencias(
      String busqueda,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> profesores) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> coincidencias = [];
    for (var profesor in profesores) {
      if (profesor
          .data()['nombre']
          .toString()
          .toLowerCase()
          .contains(busqueda.toLowerCase())) {
        coincidencias.add(profesor);
      }
    }
    return coincidencias;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // bool d = dis(context);
    return Scaffold(
      appBar: getAppBar('Agenda de Profesores', context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: t,
              decoration: const InputDecoration(
                hintText: 'Buscar',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          StreamBuilder(
            stream: c.stremFire,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasData) {
                return FutureBuilder(
                  future: c.obtener(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          profesores =
                          coincidencias(t.text, snapshot.data ?? []);
                      return profesores.isEmpty
                          ? const Expanded(
                              child: Center(
                                child: Text('No hay resultados'),
                              ),
                            )
                          : Expanded(
                              child: ListView(
                                children: [
                                  for (var profesor in profesores
                                    ..sort((a, b) => a
                                        .data()['nombre']
                                        .compareTo(b.data()['nombre'])))
                                    ListTile(
                                      title: Text(
                                        profesor.data()['nombre'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      leading: Text(
                                        profesor.data()['id'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/info_prof',
                                            arguments: profesor.data());
                                      },
                                    )
                                ],
                              ),
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
        ],
      ),
    );
  }
}

// class name extends StatefulWidget {
//   const name({super.key});

//   @override
//   State<name> createState() => _nameState();
// }

// class _nameState extends State<name> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
