import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Horario extends HiveObject {
  @HiveField(0)
  late String titular;
  @HiveField(1)
  late String materia;
  @HiveField(2)
  late String maestroAuxiliar;
  @HiveField(3)
  late String cambioDeSalon;
  @HiveField(4)
  late String grado;
  @HiveField(5)
  late String clave;
  @HiveField(6)
  late Map<String, dynamic> fechas;
  @HiveField(7)
  late String grupo;

  Horario({
    required this.titular,
    required this.materia,
    required this.maestroAuxiliar,
    required this.cambioDeSalon,
    required this.grado,
    required this.clave,
    required this.fechas,
    required this.grupo,
  });
  @override
  String toString() {
    return 'Horario{ titular: $titular, materia: $materia, maestro_auxiliar: $maestroAuxiliar, cambio_de_salon: $cambioDeSalon, grado: $grado, grupo: $grupo, clave: $clave, fechas: $fechas}';
  }

  Horario.fromMap(Map<String, dynamic> map) {
    titular = map['titular'];
    materia = map['materia'];
    maestroAuxiliar = map['maestro_auxiliar'];
    cambioDeSalon = map['cambio_de_salon'];
    grado = map['grado'];
    clave = map['clave'];
    fechas = map['fechas'];
    grupo = map['grupo'];
  }

  Map<String, dynamic> toMap() {
    return {
      'titular': titular,
      'materia': materia,
      'grado': grado,
      'clave': clave,
      'fechas': fechas,
      'grupo': grupo,
    };
  }
}

class HorarioAdapter extends TypeAdapter<Horario> {
  @override
  final typeId = 1;

  @override
  Horario read(BinaryReader reader) {
    return Horario(
      titular: reader.readString(),
      materia: reader.readString(),
      maestroAuxiliar: reader.readString(),
      cambioDeSalon: reader.readString(),
      grado: reader.readString(),
      clave: reader.readString(),
      fechas: reader.readMap().cast<String, dynamic>(),
      grupo: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Horario obj) {
    writer.writeString(obj.titular);
    writer.writeString(obj.materia);
    writer.writeString(obj.maestroAuxiliar);
    writer.writeString(obj.cambioDeSalon);
    writer.writeString(obj.grado);
    writer.writeString(obj.clave);
    writer.writeMap(obj.fechas);
    writer.writeString(obj.grupo);
  }
}
