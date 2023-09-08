import 'package:checadordeprofesores/utils/responsive_utils.dart';
import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:checadordeprofesores/widgets/tarjeta_asistencia.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import '../../controllers/rerecorrido_controller.dart';
import '../../utils/date_utils.dart';

class RecorridoView extends StatefulWidget {
  const RecorridoView({super.key});

  @override
  State<RecorridoView> createState() => _RecorridoViewState();
}

class _RecorridoViewState extends State<RecorridoView> {
  RecorridoControlador c = RecorridoControlador();
  GroupButtonController b = GroupButtonController();

  int i = 0;

  @override
  void initState() {
    super.initState();
    b.selectIndex(i);
    iniciarhorarioActual();
  }

  @override
  Widget build(BuildContext context) {
    bool d = dis(context);
    b.selectIndex(i);
    PageController p = PageController(initialPage: i);
    return Scaffold(
      appBar: getAppBar(
        'Lista de Asistencia',
        context,
        leading: true,
      ),
      body: StreamBuilder(
        stream: c.stremFire,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasData) {
            return FutureBuilder(
              future: c.obtener(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: int.parse(horarioActual.split(':')[0]) >
                                    (horaBase - 1)
                                ? () {
                                    restarhorarioActual();
                                    setState(() {});
                                  }
                                : null,
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: d ? 40 : 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              horarioActual,
                              style: TextStyle(
                                fontSize: d ? 30 : 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: int.parse(horarioActual.split(':')[0]) <
                                    horaBase
                                ? () {
                                    sumarhorarioActual();
                                    setState(() {});
                                  }
                                : null,
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: d ? 40 : 30,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: d ? 20 : 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: GroupButton(
                                controller: b,
                                buttons: c.bloques,
                                onSelected: (value, index, isSelected) {
                                  // c.indexB = index;
                                  p.jumpToPage(
                                    index,
                                    // duration: const Duration(milliseconds: 500),
                                    // curve: Curves.ease,
                                  );
                                },
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
                                  borderRadius:
                                      BorderRadius.circular(d ? 60 : 30),
                                  unselectedBorderColor: Colors.teal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: PageView.builder(
                          controller: p,
                          onPageChanged: (index) {
                            b.selectIndex(index);
                          },
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            i = index;
                            return c.getSalones(c.bloques[index]).isNotEmpty
                                ? SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        for (var salon
                                            in c
                                                .getSalones(c.bloques[index])
                                                .keys
                                                .toList()
                                              ..sort())
                                          for (var clase in c
                                              .getSalones(
                                                  c.bloques[index])[salon]
                                              .values)
                                            TarjetaAsistencia(clase),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  )
                                : const Center(
                                    child: Text('No hay clases'),
                                  );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          } else if (snapshot.hasError) {
            return const Text('Error al obtener los datos');
          } else {
            return const Text('No hay datos');
          }
        },
      ),
    );
  }
}
