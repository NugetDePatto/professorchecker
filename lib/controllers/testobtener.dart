import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity/connectivity.dart';

Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}

Future obtenerx() async {
  Source cache = Source.cache;
  Source server = Source.server;

  FirebaseFirestore db = FirebaseFirestore.instance;

  var box = GetStorage();

  var cacheTime = box.read('cacheTime');

  //Su cache es null, es porque es la primera vez que se ejecuta la app
  if (cacheTime == null) {
    print('null');
    var profesoresServer = await db
        .collection("ciclos")
        .doc('2023 - 3 Otoño')
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

    // await crearCalendario(profesoresServer.docs);

    return profesoresServer.docs;
  } else {
    print('not null');
    //Mi cache no es null, es porque ya se ejecuto la app antes
    if (kDebugMode) {
      print('Mi cache actual: $cacheTime');
    }

    //Si hay internet, actualizo mi cache, si no, obtengo la cache que ya tengo probablemente desactualizada
    if (await isConnected()) {
      var profesoresLinea = await db
          .collection('ciclos')
          .doc('2023 - 3 Otoño')
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
          profesoresLinea.docs.first.data()['lastUpdate'].toDate().toString(),
        );
        // await crearCalendario(profesoresLinea.docs);
      }
    }

    //obtengo mi cache con datos actualizados o no
    var profesores = await db
        .collection('ciclos')
        .doc('2023 - 3 Otoño')
        .collection('profesores')
        .orderBy('lastUpdate', descending: true)
        .get(
          GetOptions(source: cache),
        );
    if (kDebugMode) {
      print('se trajeron del cache: ${profesores.docs.length}');
    }
    //actualizo cache

    return profesores.docs;
  }
}
