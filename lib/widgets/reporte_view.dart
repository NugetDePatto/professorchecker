import 'package:checadordeprofesores/controllers/tarjeta_controller.dart';
import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class ReporteView extends StatefulWidget {
  const ReporteView({super.key});

  @override
  State<ReporteView> createState() => _ReporteViewState();
}

class _ReporteViewState extends State<ReporteView> {
  GroupButtonController b = GroupButtonController();
  TextEditingController tP = TextEditingController();
  TextEditingController tS = TextEditingController();

  List<String> sugerencias() {
    return b.selectedIndex == 0
        ? [
            'Envio Auxiliar en su lugar',
            'Salon Vacio',
          ]
        : [
            'Falta de Mobiliario',
            'Aire Acondicionado Defectuoso',
            'Problemas de Iluminación',
            'Escasez de Asientos',
            'Ausencia de Mesas',
            'Condiciones Precarias del Mobiliario',
          ];
  }

  @override
  void initState() {
    super.initState();
    b.selectIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    final materia = ModalRoute.of(context)?.settings.arguments as Map;
    TarjetaController t =
        TarjetaController(datos: materia as Map<String, dynamic>);
    return Scaffold(
      appBar: getAppBar('Crear reporte', context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Titular: ', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Text(materia['titular'],
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Aula: ', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Text(materia['aula'], style: const TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Materia: ', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Text(materia['materia'],
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          const Text('¿A quien va dirigido el reporte?',
              style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          GroupButton(
            controller: b,
            buttons: const ['Profesor', 'Salón'],
            options: const GroupButtonOptions(
              mainGroupAlignment: MainGroupAlignment.spaceAround,
            ),
            onSelected: (value, index, isSelected) {
              setState(() {});
            },
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
          ),
          // 0 == profesor, 1 == salon
          // b.selectedIndex == 0 ? const Text('Profesor') : const Text('Salón'),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: [
                Text(
                  'Sugerencias:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (var s in sugerencias())
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: OutlinedButton(
                    onPressed: () {
                      if (b.selectedIndex == 0) {
                        tP.text = '${tP.text}$s\n';
                      } else {
                        tS.text = '${tS.text}$s\n';
                      }
                    },
                    child: Text(
                      s,
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.teal,
                ),
              ),
              child: TextField(
                controller: b.selectedIndex == 0 ? tP : tS,
                decoration: InputDecoration(
                  hintText:
                      'Escribe aquí tu reporte para ${b.selectedIndex == 0 ? 'el profesor' : 'el salón'}',
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
            ),
          ),
        ],
      ),
      //botones de cancelar y aceptar
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: TextButton.icon(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text('Cancelar', style: TextStyle(fontSize: 20)),
                icon: const Icon(Icons.close),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.green),
                ),
                onPressed: () {
                  if (tP.text.isNotEmpty || tS.text.isNotEmpty) {
                    if (b.selectedIndex == 0) {
                      t.crearReporte(tP.text, true);
                    } else {
                      t.crearReporte(tS.text, false);
                    }
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('El campo de texto esta vacio...'),
                      ),
                    );
                  }
                },
                label: const Text('Aceptar', style: TextStyle(fontSize: 20)),
                icon: const Icon(Icons.check),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:checadordeprofesores/controllers/rerecorrido_controller.dart';
// import 'package:checadordeprofesores/utils/date_utils.dart';
// import 'package:checadordeprofesores/widgets/app_bar.dart';
// import 'package:checadordeprofesores/widgets/tarjeta_asistencia.dart';
// import 'package:flutter/material.dart';
// import 'package:group_button/group_button.dart';

// import '../utils/responsive_utils.dart';

// class TestGB extends StatefulWidget {
//   const TestGB({super.key});

//   @override
//   State<TestGB> createState() => _TestGBState();
// }

// class _TestGBState extends State<TestGB> {
//   RecorridoControlador r = RecorridoControlador();
//   GroupButtonController b = GroupButtonController();

//   int index = 0;

//   @override
//   void initState() {
//     super.initState();
//     iniciarhorarioActual();
//   }

//   @override
//   Widget build(BuildContext context) {
//     PageController p = PageController(initialPage: index);
//     b.selectIndex(index);
//     bool d = dis(context);
//     return Scaffold(
//       appBar: getAppBar('Hora: $horarioActual', context),
//       body: StreamBuilder(
//         stream: r.stremFire,
//         builder: (context, s) {
//           if (s.connectionState == ConnectionState.waiting || s.hasData) {
//             return FutureBuilder(
//               future: r.obtener(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else {
//                   return Column(
//                     children: [
//                       Row(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           GroupButton(
//                             controller: b,
//                             onSelected: (value, index, isSelected) {
//                               p.animateToPage(
//                                 index,
//                                 duration: const Duration(milliseconds: 500),
//                                 curve: Curves.ease,
//                               );
//                               this.index = index;
//                             },
//                             buttons: const ['A', 'B', 'C', 'D', 'DEI'],
//                             options: GroupButtonOptions(
//                               mainGroupAlignment:
//                                   MainGroupAlignment.spaceBetween,
//                               buttonHeight: d ? 60 : 40,
//                               buttonWidth: d ? 100 : 60,
//                               selectedColor: Colors.teal,
//                               selectedTextStyle: TextStyle(
//                                 fontSize: d ? 25 : 18,
//                                 color: Colors.white,
//                               ),
//                               unselectedTextStyle: TextStyle(
//                                 fontSize: d ? 25 : 18,
//                                 color: Colors.white,
//                               ),
//                               unselectedColor: Colors.grey[900],
//                               borderRadius: BorderRadius.circular(d ? 60 : 30),
//                               unselectedBorderColor: Colors.teal,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Expanded(
//                         child: PageView.builder(
//                           controller: p,
//                           onPageChanged: (value) {
//                             b.selectIndex(value);
//                             index = value;
//                           },
//                           itemCount: 5,
//                           itemBuilder: (context, index) {
//                             return SingleChildScrollView(
//                               child: Column(
//                                 children: [
//                                   for (var salon
//                                       in r.getSalones(r.bloques[index]).values)
//                                     for (var clase in salon.values)
//                                       TarjetaAsistencia(clase)
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             );
//           } else if (s.hasError) {
//             return const Text('Error al obtener los datos');
//           } else {
//             return const Text('No hay datos');
//           }
//         },
//       ),
//     );
//   }
// }
