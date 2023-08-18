String get horaActual => '${DateTime.now().hour}:${DateTime.now().minute}';

String horarioActual = '';

iniciarhorarioActual() {
  horarioActual = '${DateTime.now().hour}:00 - ${DateTime.now().hour + 1}:00';
}

int get horaBase => DateTime.now().hour;

restarhorarioActual() {
  var hora = (int.parse(horarioActual.split(':')[0]) - 1) % 24;
  horarioActual = '$hora:00 - ${hora + 1}:00';
}

sumarhorarioActual() {
  var hora = (int.parse(horarioActual.split(':')[0]) + 1) % 24;
  horarioActual = '$hora:00 - ${hora + 1}:00';
}

String get fechaActual =>
    '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';

int get diaActual => DateTime.now().weekday;
