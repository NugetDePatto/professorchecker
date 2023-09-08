import 'package:checadordeprofesores/controllers/calendario_controller.dart';
import 'package:checadordeprofesores/utils/responsive_utils.dart';
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

  showEditarHorario(Map<String, dynamic> datos) {
    bool d = dis(context);
    int total = int.parse(datos['hrsSem'].toString().split(':')[0]);

    List<TextEditingController> inicio =
        List.generate(7, (index) => TextEditingController());

    List<TextEditingController> fin =
        List.generate(7, (index) => TextEditingController());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Horario'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            // mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < diasSemana.length; i++)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(diasSemana[i]),
                      const Spacer(),
                      Row(
                        children: [
                          SizedBox(
                            width: d ? 130 : 70,
                            child: TextField(
                              controller: inicio[i],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Inicio',
                              ),
                              readOnly: true,
                              onTap: () async {
                                var hora = await showHora();

                                if (hora != null) {
                                  int horaInicio =
                                      int.parse(hora.split(':')[0]);
                                  // inicio[i].text = hora;
                                  if (horaInicio > 21 || horaInicio < 7) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'La hora de inicio debe ser entre las 7:00 y las 21:00 horas',
                                        ),
                                      ),
                                    );
                                  } else {
                                    inicio[i].text = hora;
                                  }
                                }

                                // state(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: d ? 130 : 70,
                            child: TextField(
                              controller: fin[i],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Fin',
                              ),
                              readOnly: true,
                              onTap: () async {
                                if (inicio[i].text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Seleccione el inicio de la clase antes',
                                      ),
                                    ),
                                  );
                                } else {
                                  var hora = await showHora();
                                  if (hora != null) {
                                    int horaInicio =
                                        int.parse(inicio[i].text.split(':')[0]);
                                    int horaFin = int.parse(hora.split(':')[0]);
                                    if (horaFin > horaInicio) {
                                      // fin[i].text = hora;
                                      if (horaFin > 21 || horaFin < 7) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'La hora de fin debe ser entre las 7:00 y las 21:00 horas',
                                            ),
                                          ),
                                        );
                                      } else {
                                        fin[i].text = hora;
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'La hora de fin debe ser mayor a la de inicio',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }

                                // state(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              List<String> horario = ['-', '-', '-', '-', '-', '-', '-'];
              int cont = 0;
              for (var i = 0; i < 7; i++) {
                String hInicio = inicio[i].text;
                String hFin = fin[i].text;
                if (hInicio.isNotEmpty) {
                  if (hFin.isNotEmpty) {
                    horario[i] = '$hInicio - $hFin';
                    int horaInicio = int.parse(hInicio.split(':')[0]);
                    int horaFin = int.parse(hFin.split(':')[0]);
                    cont += horaFin - horaInicio;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        content: Text(
                          'Seleccione la hora de fin de la clase del dia ${diasSemana[i]}',
                        ),
                      ),
                    );
                  }
                }
              }

              print(horario);

              if (cont != total) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    content: Text(
                      'El total de horas debe ser $total, horas faltantes: ${total - cont}',
                    ),
                  ),
                );
              } else {
                await eliminarMateria(datos, horario);
                String id = datos['titular'] + datos['grupo'] + datos['clave'];
                var box = GetStorage('auxiliares');

                var aux = box.read(id);

                if (aux != null) {
                  aux['horario'] = horario;
                  await box.write(id, aux);
                } else {
                  Map<String, dynamic> x = {
                    'horario': horario,
                    'salon': '',
                    'notas': '',
                    'materia': datos
                  };

                  await box.write(id, x);
                }

                print(id);
                print(box.read(id));
                await agregarHorario(datos, horario);

                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
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
                      IconButton(
                        onPressed: () {
                          showEditarHorario(j);
                        },
                        icon: const Icon(Icons.edit),
                      ),
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
