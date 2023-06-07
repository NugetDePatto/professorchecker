import 'dart:io';
import 'package:flutter/material.dart';
import '../controllers/recorrido_controller.dart';
import '../views/home/imagen_view.dart';

class CustomListTile extends StatefulWidget {
  final MapEntry<String, dynamic> entry;
  const CustomListTile({super.key, required this.entry});

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  RecorridoController recoC = RecorridoController();
  File? imagen;

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
                widget.entry.key,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
                      Text(
                        '${recoC.horario(widget.entry).titular.toUpperCase()} / ${recoC.horario(widget.entry).maestroAuxiliar.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const Text(
                    'Titular / Auxiliar',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Text(
                        '${recoC.horario(widget.entry).clave.toUpperCase()} / ${recoC.horario(widget.entry).materia.toUpperCase()} / ${recoC.horario(widget.entry).grado.toUpperCase()}° ${recoC.horario(widget.entry).grupo.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const Text(
                    'Clave / Materia / Grado y Grupo',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Text(
                        recoC.horarioKey(widget.entry).toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const Text(
                    'Horario',
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
                        recoC.guardarObservacion(
                          widget.entry,
                          con.text,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.report_problem_rounded,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 50),
          Column(
            children: [
              recoC.obtenerImagen(widget.entry) == null
                  ? SizedBox(
                      height: 90,
                      width: 90,
                      child: IconButton(
                        iconSize: 50,
                        onPressed: () async {
                          await recoC.guardarImagenAsistencia(widget.entry);
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
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImageViewer(entry: widget.entry),
                          ),
                        );
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
                              recoC.obtenerImagen(widget.entry)!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(width: 50),
          Transform.scale(
            scale: 2.5,
            child: Checkbox(
              fillColor: MaterialStateProperty.all(Colors.blueAccent),
              value: recoC.crearFecha(widget.entry),
              onChanged: (value) {
                recoC.asistencia(widget.entry);
                setState(() {});
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
