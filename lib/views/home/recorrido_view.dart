import 'package:checadordeprofesores/controllers/recorrido_controller.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import '../../widgets/CustomListTile.dart';

class RecorridoView extends StatefulWidget {
  const RecorridoView({super.key});

  @override
  State<RecorridoView> createState() => _RecorridoViewState();
}

class _RecorridoViewState extends State<RecorridoView> {
  RecorridoController recoC = RecorridoController();
  GroupButtonController controller = GroupButtonController();
  PageController pageController = PageController();
  bool verTodos = true;
  bool cambiar = false;

  @override
  void initState() {
    super.initState();
    controller.selectIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: getAppBar(
      //   recoC.horaRecorridoActual,
      //   [
      //     IconButton(
      //       onPressed: () {
      //         setState(() {
      //           verTodos = !verTodos;
      //         });
      //       },
      //       icon: Icon(verTodos ? Icons.visibility : Icons.visibility_off),
      //     ),
      //     IconButton(
      //       onPressed: () {
      //         setState(() {
      //           cambiar = !cambiar;
      //         });
      //       },
      //       icon: Icon(
      //           cambiar ? Icons.swipe_right_sharp : Icons.swipe_left_sharp),
      //     )
      //   ],
      //   context,
      // ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(recoC.horaRecorridoActual),
        titleTextStyle: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        centerTitle: true,
        toolbarHeight: 200,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                verTodos = !verTodos;
              });
            },
            icon: Icon(
              verTodos ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(width: 30),
          IconButton(
            onPressed: () {
              setState(() {
                cambiar = !cambiar;
              });
            },
            icon: Icon(
              cambiar ? Icons.swipe_right_sharp : Icons.swipe_left_sharp,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(width: 30),
        ],
      ),
      persistentFooterAlignment: AlignmentDirectional.bottomCenter,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (pageController.page! < 3) {
            pageController.nextPage(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeIn);
          } else {
            pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeIn,
            );
          }
          setState(() {});
        },
        label: const Text('Siguiente'),
        icon: const Icon(Icons.arrow_forward),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GroupButton(
              controller: controller,
              options: const GroupButtonOptions(
                elevation: 0,
                groupingType: GroupingType.row,
                mainGroupAlignment: MainGroupAlignment.spaceBetween,
              ),
              buttons: cambiar
                  ? ['400\'s', '300\'s', '200\'s', '100\'s']
                  : ['100\'s', '200\'s', '300\'s', '400\'s'],
              onSelected: (value, index, isSelected) {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeIn,
                );
              },
              buttonBuilder: (selected, value, context) => AnimatedContainer(
                height: 150,
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: selected ? Colors.teal : Colors.grey[900],
                  border: Border.all(color: Colors.teal, width: 2),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                controller.selectIndex(value);
              },
              children: [
                ListView(
                  children: [
                    ...recoC
                        .porBloque(verTodos, cambiar ? '4' : '1')
                        .entries
                        .map(
                      (e) {
                        return CustomListTile(entry: e);
                      },
                    ).toList(),
                  ],
                ),
                ListView(
                  children: [
                    ...recoC
                        .porBloque(verTodos, cambiar ? '3' : '2')
                        .entries
                        .map(
                      (e) {
                        return CustomListTile(entry: e);
                      },
                    ).toList(),
                  ],
                ),
                ListView(
                  children: [
                    ...recoC
                        .porBloque(verTodos, cambiar ? '2' : '3')
                        .entries
                        .map(
                      (e) {
                        return CustomListTile(entry: e);
                      },
                    ).toList(),
                  ],
                ),
                ListView(
                  children: [
                    ...recoC
                        .porBloque(verTodos, cambiar ? '1' : '4')
                        .entries
                        .map(
                      (e) {
                        return CustomListTile(entry: e);
                      },
                    ).toList(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
