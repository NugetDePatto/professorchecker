// import 'package:checadordeprofesores/controllers/calendario_controller.dart';
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
    'Viernes'
  ];

  Map<dynamic, dynamic> argumentos = {};

  List<dynamic> horarioOficial = [];

  List<dynamic> horarioAuxiliar = ['', '', '', '', '', '', ''];

  List<dynamic> salonesOficial = [];

  List<dynamic> salonesAuxiliar = ['', '', '', '', '', '', ''];

  List<TextEditingController> cons =
      List.generate(10, (index) => TextEditingController());

  List<TextEditingController> salones =
      List.generate(5, (index) => TextEditingController());

  bool primeraVez = true;

  @override
  Widget build(BuildContext context) {
    argumentos =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    inicio();

    return Scaffold(
      appBar: getAppBar('Horario y Salon', context),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text('Lunes:', 'i'),
                  text(horarioOficial[0], 'c'),
                  text(salonesOficial[0], 'd')
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  getTextField(cons[0], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(cons[1], 'Fin'),
                  const SizedBox(width: 20),
                  getTextFieldSalon(salones[0], 'Salon'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text('Martes:', 'i'),
                  text(horarioOficial[1], 'c'),
                  text(salonesOficial[1], 'd')
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  getTextField(cons[2], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(cons[3], 'Fin'),
                  const SizedBox(width: 20),
                  getTextFieldSalon(salones[1], 'Salon'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text('Miercoles:', 'i'),
                  text(horarioOficial[2], 'c'),
                  text(salonesOficial[2], 'd')
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  getTextField(cons[4], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(cons[5], 'Fin'),
                  const SizedBox(width: 20),
                  getTextFieldSalon(salones[2], 'Salon'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text('Jueves:', 'i'),
                  text(horarioOficial[3], 'c'),
                  text(salonesOficial[3], 'd')
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  getTextField(cons[6], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(cons[7], 'Fin'),
                  const SizedBox(width: 20),
                  getTextFieldSalon(salones[3], 'Salon'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text('Viernes:', 'i'),
                  text(horarioOficial[4], 'c'),
                  text(salonesOficial[4], 'd')
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  getTextField(cons[8], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(cons[9], 'Fin'),
                  const SizedBox(width: 20),
                  getTextFieldSalon(salones[4], 'Salon'),
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

  Future cambiarHorario() async {
    GetStorage box = GetStorage('auxiliares');

    List<String> newHorario = List.generate(7, (index) => '-');

    List<String> newSalones = List.generate(7, (index) => '-');

    for (int i = 0; i < 10; i += 2) {
      if (cons[i].text != '' && cons[i + 1].text != '') {
        newHorario[(i / 2).floor()] =
            '${cons[i].text}:00 - ${int.parse(cons[i + 1].text)}:00';
      }
    }

    for (int i = 0; i < 5; i++) {
      if (salones[i].text != '') {
        newSalones[i] = salones[i].text;
      }
    }

    String key =
        argumentos['titular'] + argumentos['grupo'] + argumentos['clave'];

    var aux = box.read(key);

    if (aux == null) {
      await box.write(
        key,
        {
          'horario': newHorario,
          'materia': argumentos,
          'salones': newSalones,
        },
      );
    } else {
      aux['horario'] = newHorario;
      aux['materia'] = argumentos;
      aux['salones'] = newSalones;

      await box.write(key, aux);
    }

    // await agregarHorario(argumentos, newHorario, salones);
  }

  void inicio() {
    horarioOficial = argumentos['horario'];

    if (primeraVez) {
      for (var x in horarioOficial) {
        if (x != '-') {
          salonesOficial.add(argumentos['aula']);
        } else {
          salonesOficial.add('-');
        }
      }

      GetStorage box = GetStorage('auxiliares');
      String key =
          argumentos['titular'] + argumentos['grupo'] + argumentos['clave'];
      if (box.read(key) != null) {
        horarioAuxiliar = box.read(key)['horario'];
        salonesAuxiliar = box.read(key)['salones'];
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

      for (int i = 0; i < 5; i++) {
        if (salonesAuxiliar[i] != '-' && salonesAuxiliar[i] != '') {
          salones[i].text = salonesAuxiliar[i];
        }
      }

      primeraVez = false;
    }
  }

  text(String label, align) {
    return SizedBox(
      width: 150,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: align == 'i'
            ? TextAlign.start
            : align == 'c'
                ? TextAlign.center
                : TextAlign.end,
      ),
    );
  }

  getTextFieldSalon(TextEditingController c, String label,
      {Function? onChanged}) {
    return Expanded(
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          hintText: 'Ej. D-401',
        ),
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
