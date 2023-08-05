import 'package:flutter/material.dart';

verMasDialog(BuildContext context, Map<String, dynamic> info) {
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
              Text('Suplente:  ${info['suplente'].toString().toUpperCase()}'),
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
                      'Horario:',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < info['horario'].length; i++)
                    if (info['horario'][i] != '-')
                      Column(
                        children: [
                          Text(dias[i]),
                          Text(info['horario'][i]),
                        ],
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
