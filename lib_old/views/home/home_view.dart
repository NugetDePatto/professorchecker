import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/responsive_utils.dart';
import '../../widgets/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int conteo = 0;

  int total = 0;

  bool estaEjecutando = false;

  StreamController<int> imageCountController = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    var d = dis(context);
    total = GetStorage('imagenes').getKeys().length;
    return Scaffold(
      appBar: getAppBar(
        'ASISTENCIA UAT',
        context,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/options');
            },
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(500, d ? 150 : 100),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/recorrido').then((value) {
                    setState(() {});
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_run, size: d ? 60 : 40),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        'Iniciar Recorrido',
                        style: TextStyle(
                          fontSize: d ? 40 : 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(500, d ? 150 : 100),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/asistencia').then((value) {
                    setState(() {});
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, size: d ? 60 : 40),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        'Asistencia Individual',
                        style: TextStyle(
                          fontSize: d ? 40 : 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(500, d ? 150 : 100),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/agenda',
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person, size: d ? 60 : 40),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        'Profesores',
                        style: TextStyle(
                          fontSize: d ? 40 : 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(500, d ? 150 : 100),
                ),
                onPressed: () async {
                  if (!estaEjecutando) {
                    estaEjecutando = true;
                    imageCountController.add(0);
                    GetStorage imagenes = GetStorage('imagenes');

                    List<String> keys = imagenes.getKeys().toList();

                    if (keys.isNotEmpty) {
                      final storage = FirebaseStorage.instance.ref();

                      total = keys.length;

                      for (String i in keys) {
                        String ruta = 'images/$i.jpg';
                        await storage
                            .child(ruta)
                            .putFile(File(imagenes.read(i)['imagen']));
                        await imagenes.remove(i);
                        if (kDebugMode) print('La imagen $i se subió');
                        conteo++;
                        imageCountController.add(conteo);
                      }

                      conteo = 0;
                    }
                    estaEjecutando = false;
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload, size: d ? 60 : 40),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        'Subir Imagenes',
                        style: TextStyle(
                          fontSize: d ? 40 : 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder(
                stream: imageCountController.stream,
                builder: (context, snapshot) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GetStorage('imagenes').getKeys().length == 0
                          ? const Text(
                              'No hay imagenes por subir',
                              style: TextStyle(fontSize: 20),
                            )
                          : Text(
                              'Se han subido $conteo de $total imagenes, no cierres la aplicación',
                              style: const TextStyle(fontSize: 20),
                            ),
                      const SizedBox(height: 10),
                      if (estaEjecutando)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: LinearProgressIndicator(
                            value: conteo / total,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
