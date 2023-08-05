import 'package:checadordeprofesores/utils/responsive_utils.dart';
import 'package:checadordeprofesores/views/Recorrido/vermas_dialog.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import '../controllers/rerecorrido_controller.dart';
import '../controllers/tarjeta_controller.dart';

class TarjetaAsistencia extends StatefulWidget {
  final Map<String, dynamic> salon;

  const TarjetaAsistencia(
    this.salon, {
    super.key,
  });

  @override
  State<TarjetaAsistencia> createState() => _TarjetaAsistenciaState();
}

class _TarjetaAsistenciaState extends State<TarjetaAsistencia> {
  RecorridoControlador c = RecorridoControlador();
  GroupButtonController g = GroupButtonController();
  late TarjetaController t;

  @override
  void initState() {
    super.initState();
    t = TarjetaController(datos: widget.salon);
    t.inicialzarAsistencia(g);
  }

  @override
  Widget build(BuildContext context) {
    bool d = dis(context);

    return GestureDetector(
      onTap: () {
        verMasDialog(context, widget.salon);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(d ? 70 : 50),
          border: Border.all(color: Colors.teal, width: 2),
          color: Colors.grey[900],
        ),
        child: Row(
          children: [
            SizedBox(
              width: d ? 80 : 50,
              child: Column(
                children: [
                  Text(
                    widget.salon['aula'].toString().split('-')[1],
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: d ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      widget.salon['titular'].toString().replaceRange(0, 6, ''),
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: d ? 24 : 18,
                        fontWeight: FontWeight.bold,
                      ),

                      // textAlign: TextAlign.center,
                    ),
                  ),
                  widget.salon['suplente'].toString() == 'Sin suplente'
                      ? const SizedBox()
                      : Text(
                          'SUPLE: ${widget.salon['suplente'].toString().toUpperCase()}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: d ? 24 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  botones(d)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row botones(bool d) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: d ? 80 : 50,
          height: d ? 80 : 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue,
              width: 2,
            ),
          ),
          child: IconButton(
            iconSize: d ? 40 : 30,
            color: Colors.blue,
            onPressed: () async {},
            icon: const Icon(
              Icons.report_sharp,
            ),
          ),
        ),
        const Spacer(),
        Container(
          width: d ? 80 : 50,
          height: d ? 80 : 50,
          decoration: BoxDecoration(
            shape: t.existeImagen() ? BoxShape.rectangle : BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: t.existeImagen()
              ? Image.file(
                  t.obtenerImagen(),
                  fit: BoxFit.cover,
                )
              : IconButton(
                  iconSize: d ? 40 : 30,
                  color: Colors.white,
                  onPressed: () async {
                    await t.tomarImagen();
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  icon: const Icon(
                    Icons.camera_alt_sharp,
                  ),
                ),
        ),
        const Spacer(),
        Container(
          color: Colors.white,
          height: d ? 70 : 40,
          width: 2,
        ),
        const Spacer(),
        checkProfesor(d),
      ],
    );
  }

  Widget checkProfesor(bool d) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10, top: 10),
      child: GroupButton(
        controller: g,
        buttons: const ['f', 't'],
        onSelected: (value, index, isSelected) {
          if (value == 'f') {
            t.ponerAsistencia(false);
          } else {
            t.ponerAsistencia(true);
          }
        },
        buttonBuilder: (selected, value, context) => AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: d ? 80 : 50,
          width: d ? 80 : 50,
          decoration: BoxDecoration(
            color: selected
                ? value == 't'
                    ? Colors.green
                    : Colors.red
                : Colors.transparent,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: value == 't'
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: d ? 50 : 30,
                )
              : Icon(
                  Icons.close,
                  color: Colors.white,
                  size: d ? 50 : 30,
                ),
        ),
      ),
    );
  }
}
