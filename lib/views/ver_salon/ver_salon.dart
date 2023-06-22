import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class VerSalon extends StatelessWidget {
  const VerSalon({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> mapa =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String salon = mapa['salon'];
    // Salon objeto = mapa['objeto'];

    return Scaffold(
      appBar: getAppBar('Salon $salon', [], context),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profesor : Ing. Salazar Herrera Juan Carlos',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 50,
              ),
            ),
            const Text(
              'Materia : Practicas Pre-Profesionales',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 50,
              ),
            ),
            const Text(
              'Grado y Grupo : 2 G',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 50,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                const Text(
                  'Asistencia: ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {},
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30),
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {},
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
              ],
            ),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.photo_camera,
                  size: 90,
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 30,
                  ),
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {},
                child: const Text(
                  'Reportar problema',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
