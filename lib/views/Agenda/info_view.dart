// import 'package:checadordeprofesores/controllers/calendario_controller.dart';
// import 'package:checadordeprofesores/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

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

  showHora() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: 0),
    );

    if (pickedTime != null) {
      return '${pickedTime.hour}:00';
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> p =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // print(p);
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
          for (var j in p['materias'].values)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.teal),
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${j['materia']}',
                          style: const TextStyle(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (String choice) {
                          // Aquí puedes manejar la opción seleccionada.
                          if (choice == 'horario') {
                            // Realiza alguna acción para la opción 1.
                            Navigator.pushNamed(
                              context,
                              '/edit_materia',
                              arguments: j,
                            );
                          } else if (choice == 'salon') {
                            // Realiza alguna acción para la opción 2.
                            Navigator.pushNamed(
                              context,
                              '/edit_salon',
                              arguments: j,
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'horario',
                              child: Text('Editar Horario'),
                            ),
                            // const PopupMenuItem<String>(
                            //   value: 'salon',
                            //   child: Text('Cambiar Salon'),
                            // ),
                          ];
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${j['grupo']} - ${j['aula']}',
                        style: const TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < 7; i++)
                        if (j['horario'][i] != '-')
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                  diasSemana[i],
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  j['horario'][i].toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  horario(datos) {
    GetStorage box = GetStorage('auxiliares');

    var aux = box.read(datos['titular'] + datos['grupo'] + datos['clave']);

    if (aux != null) {
      if (aux['horario'] != null) {
        return aux['horario'];
      } else {
        return;
      }
    } else {
      return;
    }
  }
}
