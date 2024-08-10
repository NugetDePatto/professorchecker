import 'package:checadordeprofesores/normal/utils/ciclo_utils.dart';
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

  String get ciclo => ciclo_util;

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
