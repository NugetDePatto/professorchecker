import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

verMasDialog(BuildContext context, Map<dynamic, dynamic> info) {
  GetStorage box = GetStorage('auxiliares');
  String key = info['titular'] + info['grupo'] + info['clave'];

  List<dynamic> horarioAux = [];
  List<dynamic> salonesAux = [];
  String suplente = 'Sin Suplente';

  if (box.read(key) != null) {
    horarioAux = box.read(key)['horario'];
    salonesAux = box.read(key)['salones'];
    suplente = box.read(key)['suplente'];
  }

  List<String> dias = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo',
  ];
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            const Text('Mas informacion'),
            const Spacer(),
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Divider(),
              Text('Materia:  ${info['materia']}'),
              Text('Titular:  ${info['titular']}'),
              Text('Suplente:  ${suplente.toString().toUpperCase()}'),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('Clave'),
                      Text(info['clave']),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Aula'),
                      Text(info['aula']),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Grupo'),
                      Text(info['grupo']),
                    ],
                  ),
                ],
              ),
              const Divider(),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Horario Oficial:',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Wrap(
                children: [
                  for (int i = 0; i < info['horario'].length; i++)
                    if (info['horario'][i] != '-')
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Text(dias[i]),
                            Text(info['horario'][i]),
                          ],
                        ),
                      ),
                ],
              ),
              const Divider(),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Horario Auxiliar:',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Wrap(
                children: [
                  for (int i = 0; i < horarioAux.length; i++)
                    if (horarioAux[i] != '-')
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Text(dias[i]),
                            Text(horarioAux[i]),
                            Text(salonesAux[i]),
                          ],
                        ),
                      ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
        actions: const <Widget>[],
      );
    },
  );
}
