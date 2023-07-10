import 'package:checadordeprofesores/controllers/nrerecorrido_controller.dart';
import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('ASISTENCIA UAT', [], context),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(500, 200),
                ),
                onPressed: () async {
                  NewRecorridoController controller = NewRecorridoController();
                  showDialog(
                    context: context,
                    builder: (context) => FutureBuilder(
                      future: controller.iniciar(),
                      builder:
                          (BuildContext context, AsyncSnapshot<void> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          Navigator.of(context)
                              .pop(); // Cerrar el diálogo de carga
                          return const Text('');
                        }
                      },
                    ),
                  ).then((value) {
                    Navigator.pushNamed(
                      context,
                      '/prueba',
                      arguments: controller,
                    );
                  });
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_run, size: 40),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Iniciar Recorrido',
                      style: TextStyle(
                        fontSize: 40,
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
                  minimumSize: const Size(500, 200),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/agenda',
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person, size: 40),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Agenda Profesores',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
