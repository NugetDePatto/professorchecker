import 'package:another_flushbar/flushbar.dart';
import 'package:checadordeprofesores/old/salon_controller.dart';
import 'package:flutter/material.dart';

AlertDialog launchDialogToSelectClassroom(context) {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  return AlertDialog(
    contentPadding: const EdgeInsets.all(40),
    titlePadding: const EdgeInsets.all(40),
    title: const Text(
      'INGRESA AULA',
      style: TextStyle(
        fontSize: 60,
      ),
    ),
    content: TextField(
      focusNode: focusNode,
      controller: controller,
      autofocus: true,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      onSubmitted: (s) {
        if (controller.text.isNotEmpty) {
          Navigator.of(context).pop(controller.text);
        } else {
          // FocusScope.of(context).requestFocus(focusNode);
          focusNode.requestFocus();
          Flushbar(
            message: 'AULA VACÍA',
            backgroundColor: Colors.black,
            messageColor: Colors.yellow,
            messageSize: 40,
            duration: const Duration(milliseconds: 700),
          ).show(context);
        }
      },
      style: const TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
      ),
      decoration: const InputDecoration(
        hintText: 'Ejemplo: 110',
      ),
    ),
    actions: [
      TextButton(
        child: Text(
          'Cancelar',
          style: TextStyle(
            fontSize: 40,
            color: Colors.grey.shade400,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: Text(
          'Continuar',
          style: TextStyle(
            fontSize: 40,
            color: Colors.teal.shade300,
          ),
        ),
        onPressed: () {
          if (SalonController().obtenerSalon(controller.text) != null) {
            Navigator.of(context).pop({
              'salon': controller.text,
              'objeto': SalonController().obtenerSalon(controller.text),
            });
          } else {
            Flushbar(
              message: 'AULA VACÍA',
              backgroundColor: Colors.black,
              messageColor: Colors.yellow,
              messageSize: 40,
              duration: const Duration(milliseconds: 700),
            ).show(context);
          }
        },
      ),
    ],
  );
}
