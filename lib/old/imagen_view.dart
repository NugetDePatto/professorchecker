import 'package:checadordeprofesores/old/recorrido_controller.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final MapEntry<String, dynamic> entry;

  const ImageViewer({super.key, required this.entry});

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  double scale = 1.0;
  double previousScale = 1.0;
  RecorridoController recoC = RecorridoController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Viewer'),
      ),
      body: GestureDetector(
        onScaleStart: (ScaleStartDetails details) {
          previousScale = scale;
          setState(() {});
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          scale = previousScale * details.scale;
          setState(() {});
        },
        child: Center(
          child: Transform.scale(
            scale: scale,
            child: Image.file(recoC.obtenerImagen(widget.entry)!),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await recoC.guardarImagenAsistencia(widget.entry);
          setState(() {});
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
