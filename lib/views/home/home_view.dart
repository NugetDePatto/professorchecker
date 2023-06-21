import 'package:checadordeprofesores/views/home/dialog_select_classroom.dart';
import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('ASISTENCIA UAT', [], context),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(500, 200),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/recorrido',
                );
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
                  '/faltantes',
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning, size: 40),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Faltantes',
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
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
              onPressed: () {
                showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (c) {
                    return launchDialogToSelectClassroom(context);
                  },
                ).then(
                  (value) {
                    if (value != null && value != "") {
                      Navigator.pushNamed(
                        context,
                        '/ver_salon',
                        arguments: {
                          'salon': value['salon'],
                          'objeto': value['objeto'],
                        },
                      );
                    }
                  },
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 40),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Buscar Aula',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.info_outline),
      ),
    );
  }
}
