import 'package:checadordeprofesores/controllers/rerecorrido_controller.dart';
import 'package:checadordeprofesores/utils/date_utils.dart';
import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:checadordeprofesores/widgets/tarjeta_asistencia.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import '../utils/responsive_utils.dart';

class TestGB extends StatefulWidget {
  const TestGB({super.key});

  @override
  State<TestGB> createState() => _TestGBState();
}

class _TestGBState extends State<TestGB> {
  RecorridoControlador r = RecorridoControlador();
  GroupButtonController b = GroupButtonController();

  int index = 0;

  @override
  void initState() {
    super.initState();
    iniciarhorarioActual();
  }

  @override
  Widget build(BuildContext context) {
    PageController p = PageController(initialPage: index);
    b.selectIndex(index);
    bool d = dis(context);
    return Scaffold(
      appBar: getAppBar('Hora: $horarioActual', context),
      body: StreamBuilder(
        stream: r.stremFire,
        builder: (context, s) {
          if (s.connectionState == ConnectionState.waiting || s.hasData) {
            return FutureBuilder(
              future: r.obtener(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GroupButton(
                            controller: b,
                            onSelected: (value, index, isSelected) {
                              p.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                              this.index = index;
                            },
                            buttons: const ['A', 'B', 'C', 'D', 'DEI'],
                            options: GroupButtonOptions(
                              mainGroupAlignment:
                                  MainGroupAlignment.spaceBetween,
                              buttonHeight: d ? 60 : 40,
                              buttonWidth: d ? 100 : 60,
                              selectedColor: Colors.teal,
                              selectedTextStyle: TextStyle(
                                fontSize: d ? 25 : 18,
                                color: Colors.white,
                              ),
                              unselectedTextStyle: TextStyle(
                                fontSize: d ? 25 : 18,
                                color: Colors.white,
                              ),
                              unselectedColor: Colors.grey[900],
                              borderRadius: BorderRadius.circular(d ? 60 : 30),
                              unselectedBorderColor: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: p,
                          onPageChanged: (value) {
                            b.selectIndex(value);
                            index = value;
                          },
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var salon
                                      in r.getSalones(r.bloques[index]).values)
                                    for (var clase in salon.values)
                                      TarjetaAsistencia(clase)
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          } else if (s.hasError) {
            return const Text('Error al obtener los datos');
          } else {
            return const Text('No hay datos');
          }
        },
      ),
    );
  }
}
