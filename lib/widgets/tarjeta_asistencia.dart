import 'package:checadordeprofesores/utils/responsive_utils.dart';
import 'package:checadordeprofesores/views/Recorrido/vermas_dialog.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import '../controllers/rerecorrido_controller.dart';
import '../controllers/tarjeta_controller.dart';

class TarjetaAsistencia extends StatefulWidget {
  final Map<String, dynamic> salon;
  final bool isHorarioAux;

  const TarjetaAsistencia(
    this.salon, {
    this.isHorarioAux = false,
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
              width: d ? 80 : 40,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.isHorarioAux
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.teal,
                          ),
                          child: const Text('Horario Auxiliar'),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      widget.salon['titular'].toString().replaceRange(0, 6, ''),
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: d ? 24 : 18,
                        fontWeight: FontWeight.bold,
                      ),
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

  botones(bool d) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            spacing: 10,
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
                  onPressed: () {
                    // agregarReporte();
                    Navigator.of(context)
                        .pushNamed('/reporte', arguments: widget.salon);
                  },
                  icon: const Icon(
                    Icons.report_sharp,
                  ),
                ),
              ),
              //primero se evaluara si se tomo la asistencia, si si entonces se va a inhabilitar el boton, si no, comprobara si en getstorage ya se tomo la foto,
              Container(
                width: d ? 80 : 50,
                height: d ? 80 : 50,
                decoration: BoxDecoration(
                  shape: t.seTomoAsitencia
                      ? t.existeImagen
                          ? BoxShape.rectangle
                          : BoxShape.circle
                      : BoxShape.circle,
                  border: Border.all(
                    color: t.seTomoAsitencia
                        ? t.existeImagen
                            ? Colors.transparent
                            : Colors.white
                        : Colors.grey,
                    width: 2,
                  ),
                ),
                child: t.obtenerImagen() != null
                    ? Image.file(
                        t.obtenerImagen()!,
                        fit: BoxFit.cover,
                      )
                    : IconButton(
                        iconSize: d ? 40 : 30,
                        color: t.seTomoAsitencia ? Colors.white : Colors.grey,
                        onPressed: () {
                          if (t.seTomoAsitencia) {
                            if (!t.existeImagen) {
                              t.tomarYGuardarImagen().then((value) {
                                if (mounted) setState(() {});
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'La imagen ya se tomo...',
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(
                                    seconds: 1,
                                  ),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No se puede tomar la foto sin haber tomado asistencia',
                                  textAlign: TextAlign.center,
                                ),
                                duration: Duration(
                                  seconds: 1,
                                ),
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          // Icons.camera_alt_sharp,
                          t.seTomoAsitencia
                              ? t.existeImagen
                                  ? Icons.image
                                  : Icons.camera_alt_sharp
                              : Icons.camera_alt_sharp,
                        ),
                      ),
              ),
              checkProfesor(d),
            ],
          ),
        ),
      ],
    );
  }

  Widget checkProfesor(bool d) {
    return GroupButton(
      controller: g,
      buttons: const ['f', 't'],
      onSelected: (value, index, isSelected) async {
        if (value == 'f') {
          await t.addAsistenciaLocalYFS(false);
        } else {
          await t.addAsistenciaLocalYFS(true);
        }
        setState(() {});
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
    );
  }
}
