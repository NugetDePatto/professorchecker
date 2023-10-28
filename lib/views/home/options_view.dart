import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class OptionsView extends StatefulWidget {
  const OptionsView({super.key});

  @override
  State<OptionsView> createState() => _OptionsViewState();
}

class _OptionsViewState extends State<OptionsView> {
  TextEditingController c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Opciones', context),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Ingresa el nombre del Dispositivo'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: c,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Nuevo Nombre'),
                        ),
                      ),
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
                        GetStorage().write('codigo', c.text).then((value) {
                          Navigator.pop(context);
                          setState(() {});
                        });
                      },
                      child: const Text('Aceptar'),
                    )
                  ],
                ),
              );
            },
            title: const Text(
              'Cambiar Nombre del Dispositivo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              'Nombre: ${GetStorage().read('codigo')}',
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
