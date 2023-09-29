import 'package:checadordeprofesores/utils/responsive_utils.dart';
import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var d = dis(context);
    return Scaffold(
      appBar: getAppBar('ASISTENCIA UAT', context),
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
                  Navigator.pushNamed(context, '/recorrido');
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
                  Navigator.pushNamed(context, '/asistencia');
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
              const SizedBox(
                height: 30,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
