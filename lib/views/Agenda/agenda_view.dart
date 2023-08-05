import 'package:flutter/material.dart';

import '../../constants/ejemplo.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/app_bar.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool d = dis(context);
    return Scaffold(
      appBar: getAppBar('Agenda de Profesores', context),
      body: ListView(
        children: [
          for (var i in profesores.values)
            ListTile(
              title: Text(
                i['nombre'],
                style: TextStyle(fontSize: d ? 30 : 20),
              ),
              leading: Text(
                i['id']!,
                style: TextStyle(fontSize: d ? 25 : 15),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/info_prof', arguments: i);
              },
            ),
        ],
      ),
    );
  }

  Scaffold x(BuildContext context, String i) {
    return Scaffold(
      appBar: getAppBar('Informacion', context),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Text(
            i.replaceRange(0, 6, ''),
            style: const TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          Text(
            profesores[i]!['id']! +
                ' - ' +
                profesores[i]!['tipo']! +
                ' - ' +
                profesores[i]!['codigo']!,
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
          for (var j in profesores[i]['horarios'])
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
