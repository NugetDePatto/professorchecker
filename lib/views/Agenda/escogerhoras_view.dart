import 'package:checadordeprofesores/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class EscogerHorasView extends StatefulWidget {
  const EscogerHorasView({super.key});

  @override
  State<EscogerHorasView> createState() => _EscogerHorasViewState();
}

class _EscogerHorasViewState extends State<EscogerHorasView> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argumentos =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int horas = argumentos['horas'];
    return Scaffold(
      appBar: getAppBar('Escoge $horas horas', context),
    );
  }
}
