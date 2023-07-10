import 'package:checadordeprofesores/constants/bloques.dart';
import 'package:checadordeprofesores/controllers/nrerecorrido_controller.dart';
import 'package:checadordeprofesores/widgets/NewCustomListTile.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class NewRecorridoView extends StatefulWidget {
  const NewRecorridoView({super.key});

  @override
  State<NewRecorridoView> createState() => _NewRecorridoViewState();
}

class _NewRecorridoViewState extends State<NewRecorridoView> {
  NewRecorridoController recoC = NewRecorridoController();
  GroupButtonController controller = GroupButtonController();
  PageController pageController = PageController();

  List<String> bloques = [
    'A',
    'B',
    'C',
    'D',
    'DEI',
  ];

  @override
  void initState() {
    super.initState();
    recoC.iniciar();
    controller.selectIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Hora: ${recoC.horaActual}'),
        titleTextStyle: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        centerTitle: true,
        toolbarHeight: 200,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 40,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: GroupButton(
              controller: controller,
              options: const GroupButtonOptions(
                elevation: 0,
                groupingType: GroupingType.row,
                mainGroupAlignment: MainGroupAlignment.spaceBetween,
              ),
              buttons: bloques,
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
            child: SizedBox(
              child: PageView.builder(
                itemCount: bloques.length,
                controller: pageController,
                itemBuilder: (context, indexBloques) {
                  var bloque = calendario[recoC.diaActual - 1][recoC.horaActual]
                      [bloques[indexBloques]];
                  List<String> salonesOrdenados =
                      bloque == null ? [] : bloque.keys.toList()
                        ..sort();
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return bloque != null
                          ? NewCustomListTile(
                              e: bloque[salonesOrdenados[index]],
                              salon: salonesOrdenados[index])
                          : Container();
                    },
                    itemCount: bloque == null ? 0 : bloque.length,
                  );
                },
                onPageChanged: (value) {
                  controller.selectIndex(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
