import 'dart:io';
import 'package:flutter/material.dart';

import '../controllers/nrerecorrido_controller.dart';

class NewCustomListTile extends StatefulWidget {
  final Map<String, dynamic> e;
  final String salon;
  const NewCustomListTile({super.key, required this.e, required this.salon});

  @override
  State<NewCustomListTile> createState() => _NewCustomListTileState();
}

class _NewCustomListTileState extends State<NewCustomListTile> {
  NewRecorridoController recC = NewRecorridoController();
  File? imagen;
  bool asistio = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(color: Colors.teal, width: 2),
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Row(
        children: [
          Container(
            height: 130,
            width: 130,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Center(
              child: Text(
                widget.salon,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.e['titular'].toString().replaceRange(0, 6, ''),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const Text(
                    'Titular',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.e['suplente'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const Text(
                    'Suplente',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.e['materia'] + ' / ' + widget.e['grupo'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const Text(
                    'Materia /Grupo',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            iconSize: 50,
            onPressed: () {
              TextEditingController con = TextEditingController();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Escribir reporte'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: con,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Escribe el reporte',
                        ),
                        maxLines: null,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Sugerencias:',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              con.text = 'No funciona el clima';
                            },
                            child: const Text('No funciona el clima'),
                          ),
                          TextButton(
                            onPressed: () {
                              con.text = 'No hay mesabancos';
                            },
                            child: const Text('No hay mesabancos'),
                          ),
                          TextButton(
                            onPressed: () {
                              con.text = 'No hay escritorios';
                            },
                            child: const Text('No hay escritorios'),
                          ),
                        ],
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        // recoC.guardarObservacion(
                        //   widget.entry,
                        //   con.text,
                        // );
                        Navigator.pop(context);
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.report,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 30),
          Column(
            children: [
              recC.imagen == null
                  ? SizedBox(
                      height: 90,
                      width: 90,
                      child: IconButton(
                        iconSize: 50,
                        onPressed: () async {
                          await recC.guardarImagen(widget.e);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.tealAccent,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        // await Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         ImageViewer(entry: widget.entry),
                        //   ),
                        // );
                        setState(() {});
                      },
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.tealAccent,
                            width: 3,
                          ),
                          image: DecorationImage(
                            image: FileImage(
                              recC.imagen!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(width: 30),
          Transform.scale(
            scale: 2.5,
            child: Checkbox(
              fillColor: MaterialStateProperty.all(Colors.blueAccent),
              value: asistio,
              onChanged: (value) {
                setState(() {
                  asistio = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 50),
        ],
      ),
    );
  }
}

///
///mantenimeineto
///control de todas laslamparas inventario gestor de inventario reportes reparaciones cuanot tiempo dura sie sa marca es buena
///cada cuanto sepidnta fehcas de instalacion
///
///
