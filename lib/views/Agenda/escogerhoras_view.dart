import 'package:checadordeprofesores/controllers/calendario_controller.dart';
import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

class EscogerHorasView extends StatefulWidget {
  const EscogerHorasView({super.key});

  @override
  State<EscogerHorasView> createState() => _EscogerHorasViewState();
}

class _EscogerHorasViewState extends State<EscogerHorasView> {
  List<String> diaSemana = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo'
  ];

  Map<dynamic, dynamic> argumentos = {};

  List<dynamic> horarioOficial = [];

  List<dynamic> horarioAuxiliar = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];

  List<TextEditingController> cons =
      List.generate(10, (index) => TextEditingController());

  List<TextEditingController> salones =
      List.generate(5, (index) => TextEditingController());

  bool primeraVez = true;

  Future cambiarHorario() async {
    GetStorage box = GetStorage('auxiliares');

    List<String> newHorario = List.generate(7, (index) => '-');

    for (int i = 0; i < 5; i++) {
      if (cons[i].text != '' && cons[i + 1].text != '') {
        newHorario[i] =
            '${cons[i].text}:00 - ${int.parse(cons[i + 1].text)}:00';
      }
    }
    String key =
        argumentos['titular'] + argumentos['grupo'] + argumentos['clave'];

    var aux = box.read(key);

    if (aux == null) {
      await box.write(
        key,
        {'horario': newHorario, 'materia': argumentos},
      );
    } else {
      aux['horario'] = newHorario;
      aux['materia'] = argumentos;
      await box.write(key, aux);
    }

    //await eliminarMateria(argumentos);
    await agregarHorario(argumentos, newHorario);
  }

  horarioEnTexField() {
    for (int i = 0; i < 10; i + 2) {
      // if (horarioAuxiliar[(i / 2).floor()] != '-') {
      //   cons[i].text = horarioAuxiliar[(i / 2).floor()].split(':')[0];
      //   cons[i + 1].text = horarioAuxiliar[(i / 2).floor()].split(':')[1];
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    argumentos =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;

    horarioOficial = argumentos['horario'];

    if (primeraVez) {
      GetStorage box = GetStorage('auxiliares');
      String key =
          argumentos['titular'] + argumentos['grupo'] + argumentos['clave'];
      if (box.read(key) != null) {
        horarioAuxiliar = box.read(key)['horario'];
      }
      for (int i = 0; i < 10; i += 2) {
        if (horarioAuxiliar[(i / 2).floor()] != '-' &&
            horarioAuxiliar[(i / 2).floor()] != '') {
          cons[i].text = horarioAuxiliar[(i / 2).floor()].split(':')[0];
          cons[i + 1].text = horarioAuxiliar[(i / 2).floor()]
              .split('-')[1]
              .toString()
              .split(':')[0];
        }
      }
      primeraVez = false;
    }

    return Scaffold(
      appBar: getAppBar('Añadir Horario', context),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              infoGeneral(),
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Horario a añadir',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [text('Lunes:'), text(horarioOficial[0])],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  getTextField(cons[0], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(cons[1], 'Fin'),
                  const SizedBox(width: 20),
                  getTextField(salones[0], 'Salon'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [text('Martes:'), text(horarioOficial[1])],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  getTextField(cons[2], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(cons[3], 'Fin'),
                  const SizedBox(width: 20),
                  getTextField(salones[1], 'Salon'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [text('Miercoles:'), text(horarioOficial[2])],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  getTextField(cons[4], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(cons[5], 'Fin'),
                  const SizedBox(width: 20),
                  getTextField(salones[2], 'Salon'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [text('Jueves:'), text(horarioOficial[3])],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  getTextField(cons[6], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(cons[7], 'Fin'),
                  const SizedBox(width: 20),
                  getTextField(salones[3], 'Salon'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [text('Viernes:'), text(horarioOficial[4])],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  getTextField(cons[8], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(cons[9], 'Fin'),
                  const SizedBox(width: 20),
                  getTextField(salones[4], 'Salon'),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          cambiarHorario().then((value) {
            Navigator.pop(context);
          });
        },
        icon: const Icon(Icons.save),
        label: const Text('Guardar Cambios'),
      ),
    );
  }

  Text text(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  getTextField(TextEditingController c, String label, {Function? onChanged}) {
    return Expanded(
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          hintText: 'Ej. 7',
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'^([7-9]?|1[0-9]?|2[0]?)$'),
          ),
        ],
        keyboardType: TextInputType.number,
        onSubmitted: (value) {
          if (onChanged != null) {
            onChanged();
          }
        },
        onTapOutside: (event) {
          if (onChanged != null) {
            onChanged();
          }
        },
      ),
    );
  }

  Column infoGeneral() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Materia: ${argumentos['materia']}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),
        Text(
          'Titular: ${argumentos['titular']}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),
        //aula y grupo
        Text(
          'Aula: ${argumentos['aula']} ',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),
        Text(
          'Grupo: ${argumentos['grupo']} ',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),
        Text(
          'Total de horas: ${argumentos['hrsM']} ',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
