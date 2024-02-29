import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/date_utils.dart';

class RecorridoControlador {
  Map<String, dynamic> getSalones(bloque) {
    var hora = GetStorage().read('calendario')[diaActual - 1][horarioActual];
    if (hora != null) {
      return hora[bloque] ?? {};
    } else {
      return {};
    }
  }

  List<String> bloques = ['A', 'B', 'C', 'D', 'DEI'];

  Stream<DatabaseEvent> get stremFire =>
      FirebaseDatabase.instance.ref().onChildChanged;

  crearCalendario(profesores) async {
    var box = GetStorage();

    List<Map<String, dynamic>> calendario = [{}, {}, {}, {}, {}, {}, {}];

    for (var p in profesores) {
      print(p.data());
      for (var materia in p.data()['materias'].values) {
        String aula = materia['aula'];
        String bloque = aula.split('-')[0];

        String clave = '${materia['grupo']}${materia['clave']}';

        materia['horarioAux'] = ['-', '-', '-', '-', '-', '-', '-'];
        materia['tipoAula'] = bloque.contains('DEI') ? 'Laboratorio' : 'Aula';
        materia['salonAux'] = 'Sin asignar';

        for (int i = 0; i < 7; i++) {
          String horas = materia['horario'][i];
          if (horas.contains(':')) {
            int horaInicio = int.parse(horas.split(':')[0]);
            int horaFin = int.parse(horas.split('-')[1].split(':')[0]);
            while (horaInicio < horaFin) {
              horas = '$horaInicio:00 - ${horaInicio + 1}:00';
              if (calendario[i].containsKey(horas)) {
                if (calendario[i][horas]!.containsKey(bloque)) {
                  if (calendario[i][horas]![bloque].containsKey(aula)) {
                    if (kDebugMode) {
                      print('Agregando materia: $materia');
                    }
                    calendario[i][horas]![bloque][aula]![clave] = materia;
                  } else {
                    calendario[i][horas]![bloque][aula] = {clave: materia};
                  }
                } else {
                  calendario[i][horas]![bloque] = {
                    aula: {
                      clave: materia,
                    }
                  };
                }
              } else {
                calendario[i][horas] = {
                  bloque: {
                    aula: {
                      clave: materia,
                    }
                  }
                };
              }
              horaInicio++;
            }
          }
        }
      }
    }

    var aux = GetStorage().read('auxiliares');

    if (aux != null) {}

    await box.write('calendario', calendario);
    if (kDebugMode) {
      print('exito');
    }
  }

  // actualizarCalendario(profesores) async {
  //   GetStorage box = GetStorage();

  //   List<dynamic> calendario =
  //       box.read('calendario') ?? [{}, {}, {}, {}, {}, {}, {}];

  //   for (var p in profesores) {}
  // }

  agregarHorarioACalendario() {}

  String get ciclo {
    // enero a mayo = primavera
    // junio a julio = verano
    // agosto a diciembre = otoño

    int mesActual = DateTime.now().month;

    if (kDebugMode) {
      return '2023 - 3 Otoño';
    } else if (mesActual >= 1 && mesActual <= 5) {
      return '${DateTime.now().year} - 1 Primavera';
    } else if (mesActual >= 6 && mesActual <= 7) {
      return '${DateTime.now().year} - 2 Verano';
    } else {
      return '${DateTime.now().year} - 3 Otoño';
    }
  }

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> obtener() async {
    Source cache = Source.cache;
    Source server = Source.server;

    FirebaseFirestore db = FirebaseFirestore.instance;

    var box = GetStorage();

    var cacheTime = box.read('cacheTime');
    print('Entro');

    //Su cache es null, es porque es la primera vez que se ejecuta la app
    if (cacheTime == null) {
      print('Entro 1');
      var profesoresServer = await db
          .collection("ciclos")
          .doc(ciclo)
          .collection('profesores')
          .orderBy('lastUpdate', descending: true)
          .get(
            GetOptions(source: server),
          );
      await box.write('cacheTime',
          profesoresServer.docs.first.data()['lastUpdate'].toDate().toString());
      if (kDebugMode) {
        print('Mi cache es null, DateStart: ${box.read('cacheTime')}');
      }

      await crearCalendario(profesoresServer.docs);

      print('termino 1');

      return profesoresServer.docs;
    } else {
      print('Entro 2');
      //Mi cache no es null, es porque ya se ejecuto la app antes
      if (kDebugMode) {
        print('Mi cache actual: $cacheTime');
      }

      bool seActualizo = false;

      //Si hay internet, actualizo mi cache, si no, obtengo la cache que ya tengo probablemente desactualizada
      if (await isConnected()) {
        QuerySnapshot<Map<String, dynamic>> profesoresLinea;
        try {
          profesoresLinea = await db
              .collection('ciclos')
              .doc(ciclo)
              .collection('profesores')
              .where(
                'lastUpdate',
                isGreaterThan: cacheTime,
              )
              .get(
                GetOptions(source: server),
              );

          if (kDebugMode) {
            print('se trajeron de linea: ${profesoresLinea.docs.length}');
          }

          if (profesoresLinea.docs.isNotEmpty) {
            await box.write(
              'cacheTime',
              profesoresLinea.docs.first
                  .data()['lastUpdate']
                  .toDate()
                  .toString(),
            );
            seActualizo = true;
            // await crearCalendario(profesoresLinea.docs);
          }
        } catch (e) {
          if (kDebugMode) print(e);
        }
      }

      //obtengo mi cache con datos actualizados o no
      var profesores = await db
          .collection('ciclos')
          .doc(ciclo)
          .collection('profesores')
          .orderBy('lastUpdate', descending: true)
          .get(
            GetOptions(source: cache),
          );

      if (kDebugMode) {
        print('se trajeron del cache: ${profesores.docs.length}');
      }

      if (seActualizo) {
        await crearCalendario(profesores.docs);
      }

      print('termino 2');

      return profesores.docs;
    }
  }

  Future<void> rlUpdate() async {
    var rl = FirebaseDatabase.instance.ref();
    await rl.set(
      {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
  // Future obtenerAnterior() async {
  //   Source CACHE = Source.cache;
  //   Source SERVER = Source.server;

  //   FirebaseFirestore db = FirebaseFirestore.instance;

  //   var box = GetStorage();

  //   var cacheTime = box.read('cacheTime');

  //   if (cacheTime == null) {
  //     var profesoresServer = await db
  //         .collection("ciclos")
  //         .doc(ciclo)
  //         .collection('profesores')
  //         .orderBy('lastUpdate', descending: true)
  //         .get(
  //           GetOptions(source: SERVER),
  //         );

  //     await box.write('cacheTime',
  //         profesoresServer.docs.first.data()['lastUpdate'].toDate().toString());
  //     print(box.read('cacheTime').toString());

  //     await crearCalendario(profesoresServer.docs);

  //     return profesoresServer.docs;
  //   } else {
  //     var cacheTime = box.read('cacheTime');
  //     print(cacheTime.toString());

  //     //actualiza mi cache
  //     var value = await db
  //         .collection('ciclos')
  //         .doc(ciclo)
  //         .collection('profesores')
  //         .where(
  //           'lastUpdate',
  //           isGreaterThan: Timestamp.fromDate(DateTime.parse(cacheTime)),
  //         )
  //         .get(
  //           GetOptions(source: SERVER),
  //         );

  //     //obtengo mi cache con datos actualizados
  //     var profesores = await db
  //         .collection('ciclos')
  //         .doc(ciclo)
  //         .collection('profesores')
  //         .orderBy('lastUpdate', descending: true)
  //         .get(
  //           GetOptions(source: CACHE),
  //         );

  //     //actualizo cache
  //     await box.write('cacheTime',
  //         profesores.docs.first.data()['lastUpdate'].toDate().toString());

  //     print('se trajeron del server: ${value.docs.length}');
  //     if (value.docs.isNotEmpty || GetStorage().read('calendario') == null) {
  //       await crearCalendario(profesores.docs);
  //       print('se creo el calendario');
  //     }
  //     return profesores.docs;
  //   }
  // }

//   Widget listaUsers() {
//     RecorridoControlador recoC = RecorridoControlador();
//     GroupButtonController controller = GroupButtonController();
//     PageController pageController = PageController();
//     // List<dynamic> calendario = GetStorage().read('calendario');

//     List<String> bloques = [
//       'A',
//       'B',
//       'C',
//       'D',
//       'DEI',
//     ];
//     controller.selectIndex(0);
//     return FutureBuilder(
//       future: obtener(),
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         if (snapshot.hasData) {
//           return Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: GroupButton(
//                   controller: controller,
//                   options: const GroupButtonOptions(
//                     elevation: 0,
//                     groupingType: GroupingType.row,
//                     mainGroupAlignment: MainGroupAlignment.spaceBetween,
//                   ),
//                   buttons: bloques,
//                   onSelected: (value, index, isSelected) {
//                     pageController.animateToPage(
//                       index,
//                       duration: const Duration(milliseconds: 350),
//                       curve: Curves.easeIn,
//                     );
//                   },
//                   buttonBuilder: (selected, value, context) =>
//                       AnimatedContainer(
//                     height: 150,
//                     duration: const Duration(milliseconds: 150),
//                     decoration: BoxDecoration(
//                       color: selected ? Colors.teal : Colors.grey[900],
//                       border: Border.all(color: Colors.teal, width: 2),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(30.0),
//                       child: Center(
//                         child: Text(
//                           value,
//                           style: const TextStyle(
//                             fontSize: 25,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: SizedBox(
//                   child: PageView.builder(
//                     itemCount: bloques.length,
//                     controller: pageController,
//                     itemBuilder: (context, indexBloques) {
//                       var bloque =
//                           GetStorage().read('calendario')[diaActual - 1]
//                               [horarioActual][bloques[indexBloques]];
//                       List<String> salonesOrdenados =
//                           bloque == null ? [] : bloque.keys.toList()
//                             ..sort();
//                       return ListView.builder(
//                         itemBuilder: (context, index) {
//                           return bloque != null
//                               ? NewCustomListTile(
//                                   e: bloque[salonesOrdenados[index]],
//                                 )
//                               : Container();
//                         },
//                         itemCount: bloque == null ? 0 : bloque.length,
//                       );
//                     },
//                     onPageChanged: (value) {
//                       controller.selectIndex(value);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }


  // String horarioActual =
  //     '${DateTime.now().hour}:00 - ${DateTime.now().hour + 1}:00';

  // int get horaBase => DateTime.now().hour;

  // restarhorarioActual() {
  //   // print((horaBase - 1) % 24);
  //   // print(int.parse(horarioActual.split(':')[0]) % 24);
  //   var hora = (int.parse(horarioActual.split(':')[0]) - 1) % 24;
  //   horarioActual = '$hora:00 - ${hora + 1}:00';
  // }

  // sumarhorarioActual() {
  //   var hora = (int.parse(horarioActual.split(':')[0]) + 1) % 24;
  //   horarioActual = '$hora:00 - ${hora + 1}:00';
  // }

  // String get fechaActual => '${DateTime.now().day}/${DateTime.now().month}';

  // int get diaActual => DateTime.now().weekday;

  // File? imagen;

  // tomarImagen(Map<String, dynamic> e) async {
  //   //inicia el controlador
  //   ImagenController imagenController = ImagenController();

  //   String path = await imagenController.iniciar();
  //   String titular = e['titular'].toString().trim().replaceAll(' ', '-');
  //   String materia = '${e['grupo']}-${e['clave']}';
  //   String fecha =
  //       '${fechaActual.replaceFirst('/', '-')}_${horarioActual.replaceAll(' ', '')}';
  //   String codigo = generateCode(fechaActual);

  //   String ruta = '$path/${titular}_${materia}_${fecha}_$codigo.jpg';

  //   print('Ruta Final: $ruta');
  //   //metodo para tomar imagen y crear la ruta
  //   imagen = await imagenController.tomar(ruta);
  // }

  // existeImagen() {
  //   return imagen != null;
  // }

  // obtenerImagen() {
  //   return imagen;
  // }
