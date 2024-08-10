import 'package:checadordeprofesores/normal/controllers/calendario_controller.dart';
import 'package:checadordeprofesores/normal/utils/responsive_utils.dart';
import 'package:checadordeprofesores/normal/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

class EscogerHorasView extends StatefulWidget {
  const EscogerHorasView({super.key});

  @override
  State<EscogerHorasView> createState() => _EscogerHorasViewState();
}

class _EscogerHorasViewState extends State<EscogerHorasView> {
  bool primeraVez = true;

  bool d = false;

  List<String> items = ['A', 'B', 'C', 'D', 'DEI'];

  List<String> bloquesSelec = ['A', 'A', 'A', 'A', 'A', 'A', 'A'];

  List<String> diaSemana = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo'
  ];
  List<TextEditingController> conInicio =
      List.generate(7, (index) => TextEditingController());

  List<TextEditingController> conFin =
      List.generate(7, (index) => TextEditingController());

  List<TextEditingController> conSalones =
      List.generate(7, (index) => TextEditingController());

  TextEditingController conSuplente = TextEditingController();

  Map<dynamic, dynamic> materia = {};

  List<dynamic> horarioOficial = List.generate(7, (index) => '-');

  List<dynamic> salonesOficial = List.generate(7, (index) => '-');

  List<dynamic> horarioAuxiliar = List.generate(7, (index) => '-');

  List<dynamic> salonesAuxiliar = List.generate(7, (index) => '-');

  @override
  Widget build(BuildContext context) {
    init(ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>);
    return Scaffold(
      appBar: getAppBar('Horario y Salon', context, leading: true),
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
                  const Text(
                    'Suplente:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: conSuplente,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Suplente',
                        hintText: 'Ej. Juan Perez',
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: 60,
                    width: d ? 120 : null,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.teal),
                      ),
                      onPressed: () {
                        conSuplente.text = '';
                      },
                      label: const Text(
                        'Borrar',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.cleaning_services,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
                  getTextField(conInicio[0], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(conFin[0], 'Fin'),
                  const SizedBox(width: 20),
                  getDrop(0),
                  const SizedBox(width: 20),
                  getTextFieldSalon(conSalones[0], 'Salon'),
                  if (d) getBorrador(0)
                ],
              ),
              d ? const SizedBox(height: 10) : getBorrador(0),
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
                  getTextField(conInicio[1], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(conFin[1], 'Fin'),
                  const SizedBox(width: 20),
                  getDrop(1),
                  const SizedBox(width: 20),
                  getTextFieldSalon(conSalones[1], 'Salon'),
                  if (d) getBorrador(1)
                ],
              ),
              d ? const SizedBox(height: 10) : getBorrador(1),
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
                  getTextField(conInicio[2], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(conFin[2], 'Fin'),
                  const SizedBox(width: 20),
                  getDrop(2),
                  const SizedBox(width: 20),
                  getTextFieldSalon(conSalones[2], 'Salon'),
                  if (d) getBorrador(2)
                ],
              ),
              d ? const SizedBox(height: 10) : getBorrador(2),
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
                  getTextField(conInicio[3], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(conFin[3], 'Fin'),
                  const SizedBox(width: 20),
                  getDrop(3),
                  const SizedBox(width: 20),
                  getTextFieldSalon(conSalones[3], 'Salon'),
                  if (d) getBorrador(3)
                ],
              ),
              d ? const SizedBox(height: 10) : getBorrador(3),
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
                  getTextField(conInicio[4], 'Inicio'),
                  const SizedBox(width: 20),
                  getTextField(conFin[4], 'Fin'),
                  const SizedBox(width: 20),
                  getDrop(4),
                  const SizedBox(width: 20),
                  getTextFieldSalon(conSalones[4], 'Salon'),
                  if (d) getBorrador(4)
                ],
              ),
              d ? const SizedBox(height: 10) : getBorrador(4),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          String respuesta = capturarDatos();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(respuesta),
              duration: const Duration(seconds: 2),
            ),
          );
          if (respuesta == 'Datos capturados correctamente') {
            guardar().then(
              (value) {
                Navigator.pop(context);
              },
            );
          }
        },
        icon: const Icon(Icons.save),
        label: const Text('Guardar Cambios'),
      ),
    );
  }

  guardar() async {
    GetStorage box = GetStorage('auxiliares');

    String key = materia['titular'] + materia['grupo'] + materia['clave'];

    var aux = box.read(key);

    //si aux es null es porque no existe un horario en auxiliares, asi que hay que crear uno
    if (aux == null) {
      await box.write(key, {
        'horario': horarioAuxiliar,
        'materia': materia,
        'salones': salonesAuxiliar,
        'suplente': conSuplente.text,
      });
    } else {
      //si entro aqui es porque ya existe un horario en auxiliares y en el calendario, asi que hay que eliminar el anterior y agregar el nuevo

      for (int i = 0; i < 7; i++) {
        if (aux['horario'][i] != '-') {
          eliminarHora(i, aux['materia'], aux['horario'][i], aux['salones'][i]);
        } else if (aux['salones'][i] != '-') {
          eliminarHora(i, aux['materia'], aux['horario'][i], aux['salones'][i]);
        }
      }

      aux['horario'] = horarioAuxiliar;
      aux['salones'] = salonesAuxiliar;
      aux['suplente'] = conSuplente.text;
      await box.write(key, aux);
    }

    for (int i = 0; i < 7; i++) {
      if (horarioAuxiliar[i] != '-') {
        print(salonesAuxiliar[i]);
        agregarHora(i, materia, horarioAuxiliar[i], salonesAuxiliar[i]);
      } else if (salonesAuxiliar[i] != '-' && horarioOficial[i] != '-') {
        print(salonesAuxiliar[i]);
        agregarHora(i, materia, horarioOficial[i], salonesAuxiliar[i]);
      }
    }
  }

  String capturarDatos() {
    if (conSuplente.text == '') {
      conSuplente.text = 'Sin Suplente';
    }
    for (int i = 0; i < 7; i++) {
      if (conInicio[i].text != '' && conFin[i].text != '') {
        if (int.parse(conInicio[i].text) >= int.parse(conFin[i].text)) {
          return 'La hora de inicio debe ser menor a la hora de fin';
        } else {
          horarioAuxiliar[i] = '${conInicio[i].text}:00 - ${conFin[i].text}:00';
          salonesAuxiliar[i] = materia['aula'];
        }
      }
      // else {
      //   horarioAuxiliar[i] = '-';
      // }
      if (conSalones[i].text != '') {
        switch (bloquesSelec[i]) {
          case 'A':
            if (conSalones[i].text[0] == '1' &&
                conSalones[i].text.length == 3) {
              salonesAuxiliar[i] = 'A-${conSalones[i].text}';
              if (horarioAuxiliar[i] == '-') {
                horarioAuxiliar[i] = materia['horario'][i];
              }
            } else {
              return 'El salon no es valido';
            }
            break;
          case 'B':
            if (conSalones[i].text[0] == '2' &&
                conSalones[i].text.length == 3) {
              salonesAuxiliar[i] = 'B-${conSalones[i].text}';
              if (horarioAuxiliar[i] == '-') {
                horarioAuxiliar[i] = materia['horario'][i];
              }
            } else {
              return 'El salon no es valido';
            }
            break;
          case 'C':
            if (conSalones[i].text[0] == '3' &&
                conSalones[i].text.length == 3) {
              salonesAuxiliar[i] = 'C-${conSalones[i].text}';
              if (horarioAuxiliar[i] == '-') {
                horarioAuxiliar[i] = materia['horario'][i];
              }
            } else {
              return 'El salon no es valido';
            }
            break;
          case 'D':
            if (conSalones[i].text[0] == '4' &&
                conSalones[i].text.length == 3) {
              salonesAuxiliar[i] = 'D-${conSalones[i].text}';
              if (horarioAuxiliar[i] == '-') {
                horarioAuxiliar[i] = materia['horario'][i];
              }
            } else {
              return 'El salon no es valido';
            }
            break;
          case 'DEI':
            salonesAuxiliar[i] = 'DEI-${conSalones[i].text}';
            if (horarioAuxiliar[i] == '-') {
              horarioAuxiliar[i] = materia['horario'][i];
            }
            break;
          default:
            return 'El salon no es valido';
        }
      }
      // else {
      //   salonesAuxiliar[i] = '-';
      // }
    }
    return 'Datos capturados correctamente';
  }

  init(m) {
    if (primeraVez) {
      d = dis(context);
      materia = m;

      //Extraigo el horario oficial y los salones oficiales de la materia para mostrarlos en pantalla
      horarioOficial = materia['horario'];

      //como no existe un lista de salones en la materia, creo una lista de salones con el mismo tamaño que el horario oficial y le asigno un '-' a cada elemento
      for (int i = 0; i < 7; i++) {
        if (horarioOficial[i] != '-') {
          salonesOficial[i] = materia['aula'];
        } else {
          salonesOficial[i] = '-';
        }
      }

      //Inicializo los controladores de los textfields y los dropdowns con la informacion del horario y los salones auxiliares si es que existen
      var aux = GetStorage('auxiliares')
          .read(materia['titular'] + materia['grupo'] + materia['clave']);

      conSuplente.text = 'Sin Suplente';
      if (aux != null) {
        conSuplente.text = aux['suplente'];
        for (int i = 0; i < 7; i++) {
          if (aux['horario'][i] != '-') {
            conInicio[i].text = aux['horario'][i].split(':')[0];
            conFin[i].text = aux['horario'][i].split('-')[1].split(':')[0];
          }
          if (aux['salones'][i] != '-') {
            conSalones[i].text = aux['salones'][i].split('-')[1];
            bloquesSelec[i] = aux['salones'][i].split('-')[0];
          } else if (materia['horario'][i] != '-') {
            bloquesSelec[i] = materia['aula'].split('-')[0];
          }
        }
      }
      primeraVez = false;
    }
  }

  getBorrador(int i) {
    return Padding(
      padding: EdgeInsets.only(
        left: d ? 20 : 0,
        top: d ? 0 : 10,
        bottom: d ? 0 : 10,
      ),
      child: SizedBox(
        width: d ? 120 : null,
        height: d ? 60 : null,
        child: ElevatedButton.icon(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.teal),
          ),
          onPressed: () {
            setState(() {
              conInicio[i].text = '';
              conFin[i].text = '';
              conSalones[i].text = '';
              bloquesSelec[i] = materia['aula'].split('-')[0];
            });
          },
          label: const Text('Borrar', style: TextStyle(color: Colors.white)),
          icon: const Icon(Icons.cleaning_services, color: Colors.white),
        ),
      ),
    );
  }

  getDrop(int i) {
    return DropdownButton(
      value: bloquesSelec[i],
      onChanged: (value) {
        setState(() {
          bloquesSelec[i] = value.toString();
        });
      },
      items: const [
        DropdownMenuItem(
          value: 'A',
          child: Text('A'),
        ),
        DropdownMenuItem(
          value: 'B',
          child: Text('B'),
        ),
        DropdownMenuItem(
          value: 'C',
          child: Text('C'),
        ),
        DropdownMenuItem(
          value: 'D',
          child: Text('D'),
        ),
        DropdownMenuItem(
          value: 'DEI',
          child: Text('DEI'),
        ),
      ],
    );
  }

  text(String label, align) {
    return SizedBox(
      width: d ? 150 : null,
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
          hintText: 'Ej. 401',
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

  textGen(String label, align) {
    return SizedBox(
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

  Column infoGeneral() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textGen('Clave: ', 'i'),
            Expanded(child: textGen(materia['clave'], 'd')),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textGen('Materia: ', 'i'),
            Expanded(child: textGen(materia['materia'], 'd')),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textGen('Titular: ', 'i'),
            Expanded(child: textGen(materia['titular'], 'd')),
          ],
        ),
        const SizedBox(height: 5),
        //aula, grupo y hrsM
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textGen('Aula: ', 'i'),
            Expanded(child: textGen(materia['aula'], 'd')),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textGen('Grupo: ', 'i'),
            Expanded(child: textGen(materia['grupo'], 'd')),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textGen('Horas a la Semana: ', 'i'),
            Expanded(child: textGen(materia['hrsM'], 'd')),
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
