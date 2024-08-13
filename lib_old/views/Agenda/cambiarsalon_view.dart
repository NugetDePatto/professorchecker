import 'package:flutter/material.dart';

import '../../widgets/app_bar.dart';

class CambiarSalonView extends StatefulWidget {
  const CambiarSalonView({super.key});

  @override
  State<CambiarSalonView> createState() => _CambiarSalonViewState();
}

class _CambiarSalonViewState extends State<CambiarSalonView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Cambiar Salon', context),
    );
  }
}
