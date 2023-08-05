import 'package:hive/hive.dart';
import 'horario_model.dart';

@HiveType(typeId: 0)
class Salon extends HiveObject {
  @HiveField(0)
  late List<String> observaciones;
  @HiveField(1)
  late Map<String, Horario> horarios;

  Salon({
    required this.observaciones,
    required this.horarios,
  });

  @override
  String toString() {
    return 'Salon{ observaciones: $observaciones, horarios: $horarios}';
  }

  Salon.fromMap(Map<String, dynamic> map) {
    observaciones = map['observaciones'];
    horarios = {};
    map['horarios'].forEach((key, value) {
      horarios[key] = Horario.fromMap(value);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'observaciones': observaciones,
      'horarios': horarios,
    };
  }
}

class SalonAdapter extends TypeAdapter<Salon> {
  @override
  final typeId = 0;

  @override
  Salon read(BinaryReader reader) {
    return Salon(
      observaciones: reader.readList().cast<String>(),
      horarios: reader.readMap().cast<String, Horario>(),
    );
  }

  @override
  void write(BinaryWriter writer, Salon obj) {
    writer.writeList(obj.observaciones);
    writer.writeMap(obj.horarios);
  }
}
