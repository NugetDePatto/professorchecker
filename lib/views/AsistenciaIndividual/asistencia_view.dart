import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:group_button/group_button.dart';

import '../../controllers/rerecorrido_controller.dart';
import '../../utils/date_utils.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/tarjeta_asistencia.dart';

class AsistenciaView extends StatefulWidget {
  const AsistenciaView({super.key});

  @override
  State<AsistenciaView> createState() => _AsistenciaViewState();
}

class _AsistenciaViewState extends State<AsistenciaView> {
  GroupButtonController g = GroupButtonController();
  TextEditingController tProf = TextEditingController();
  TextEditingController tSalon = TextEditingController();
  RecorridoControlador c = RecorridoControlador();
  // TarjetaController t = TarjetaController();

  bool estaCargando = false;

  Map<String, dynamic> coincidencias = {};

  getCoincidencias() async {
    Map<String, dynamic> aux = {};
    setState(() {
      estaCargando = true;
    });
    if (g.selectedIndex == 0 && tProf.text.isNotEmpty) {
      var profesores = await c.obtener();

      for (var element in profesores) {
        if (element.id.contains(tProf.text.toUpperCase())) {
          Map<String, dynamic> materias = element.data()['materias'];
          for (var materia in materias.values.toList()) {
            var hora = materia['horario'][diaActual - 1];
            if (hora == horarioActual) {
              aux[element.id] = materia;
            }
          }
        }
      }
    } else if (g.selectedIndex == 1 && tSalon.text.isNotEmpty) {
      //esperar medio segundo
      await Future.delayed(const Duration(milliseconds: 300));
      var salones =
          GetStorage().read('calendario')[diaActual - 1][horarioActual];
      if (salones != null) {
        for (var bloque in salones.keys) {
          for (var salon in salones[bloque].keys) {
            if (salon.contains(tSalon.text)) {
              aux[salon] = salones[bloque][salon];
            }
          }
        }
      }
    }

    coincidencias = aux;

    setState(() {
      estaCargando = false;
    });
  }

  @override
  void initState() {
    super.initState();
    g.selectIndex(0);
    iniciarhorarioActual();
  }

  @override
  Widget build(BuildContext context) {
    bool d = dis(context);
    return Scaffold(
      appBar: getAppBar('Buscador', context),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 16),
              IconButton(
                onPressed:
                    // int.parse(c.horarioActual.split(':')[0]) > c.horaBase - 1
                    //     ?
                    () {
                  restarhorarioActual();
                  getCoincidencias();
                  setState(() {});
                },
                // : null,
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: d ? 40 : 30,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  horarioActual,
                  style: TextStyle(
                    fontSize: d ? 30 : 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed:
                    // int.parse(c.horarioActual.split(':')[0]) < c.horaBase
                    //     ?
                    () {
                  sumarhorarioActual();
                  getCoincidencias();
                  setState(() {});
                },
                // : null,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: d ? 40 : 30,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 20),
          GroupButton(
            controller: g,
            buttons: const ['Profesor', 'Salón'],
            options: const GroupButtonOptions(
              mainGroupAlignment: MainGroupAlignment.spaceAround,
            ),
            buttonBuilder: (s, t, c) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.teal,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          s
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: Colors.teal,
                        ),
                        const SizedBox(width: 10),
                        Text(t),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
            onSelected: (value, index, isSelected) {
              getCoincidencias();
            },
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: g.selectedIndex == 0 ? tProf : tSalon,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: d ? 30 : 20,
                        vertical: d ? 30 : 18,
                      ),
                      hintText:
                          'Buscar por ${g.selectedIndex == 0 ? 'Profesor' : 'Salón'}',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      getCoincidencias();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.outlined(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    getCoincidencias();
                  },
                  iconSize: d ? 40 : 30,
                  padding: EdgeInsets.all(d ? 20 : 15),
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          if (tProf.text.isEmpty && g.selectedIndex == 0)
            const Expanded(
              child: Center(
                child: Text('Ingrese un profesor'),
              ),
            )
          else if (tSalon.text.isEmpty && g.selectedIndex == 1)
            const Expanded(
              child: Center(
                child: Text('Ingrese un salón'),
              ),
            )
          else if (estaCargando)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (coincidencias.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No se encontraron coincidencias'),
              ),
            )
          else
            Expanded(
              child: ListView(
                children: [
                  for (var x in coincidencias.values)
                    if (x['aula'] != null) TarjetaAsistencia(x)
                ],
              ),
            ),
        ],
      ),
    );
  }
}
// ValueListenableBuilder(
//   valueListenable: g.selectedIndex == 0 ? tProf : tSalon,
//   builder: (context, value, child) {
//     return FutureBuilder(
//       future: getCoincidencias(),
//       builder: (context, snapshot) {
//         Map<String, dynamic> coincidencias = snapshot.data ?? {};
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Expanded(
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         } else if (coincidencias.isNotEmpty) {
//           return Expanded(
//             child: ListView(
//               children: [
//                 for (var x in coincidencias.entries)
//                   TarjetaAsistencia(x.value)
//               ],
//             ),
//           );
//         } else {
//           return const Center(
//             child: Text('No se encontraron coincidencias'),
//           );
//         }
//       },
//     );
//   },
// ),
