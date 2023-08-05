import 'package:flutter/material.dart';

import '../../widgets/app_bar.dart';

class InfoProfView extends StatefulWidget {
  const InfoProfView({super.key});

  @override
  State<InfoProfView> createState() => _InfoProfViewState();
}

class _InfoProfViewState extends State<InfoProfView> {
  List<String> diasSemana = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo'
  ];
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> p =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // var p = widget.profesor;
    return Scaffold(
      appBar: getAppBar('Informacion del profesor', context),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Text(
            p['nombre'].toString().trim(),
            style: const TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          Text(
            p['id']! + ' - ' + p['tipo']! + ' - ' + p['codigo']!,
            style: const TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Divider(
            height: 20,
            thickness: 5,
            indent: 20,
            endIndent: 20,
          ),
          const Text(
            'Horarios de Clase',
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          const Divider(
            height: 20,
            thickness: 5,
            indent: 20,
            endIndent: 20,
          ),
          for (var j in p['horarios'])
            Column(
              children: [
                Text(
                  '${j['materia']} - ${j['grupo']} - ${j['aula']}',
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < j['dias'].length; i++)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                diasSemana[i],
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                j['dias'][i].toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Inscritos: ${j['inscritos']}',
                  style: const TextStyle(fontSize: 20),
                ),
                const Divider(
                  height: 20,
                  thickness: 5,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
