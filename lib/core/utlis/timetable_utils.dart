int get dayOfWeek => DateTime.now().weekday - 1;

String dayOfWeekString(int day) {
  switch (day) {
    case 0:
      return 'Lunes';
    case 1:
      return 'Martes';
    case 2:
      return 'Miércoles';
    case 3:
      return 'Jueves';
    case 4:
      return 'Viernes';
    case 5:
      return 'Sábado';
    case 6:
      return 'Domingo';
    default:
      return '';
  }
}

String get currentDate => DateTime.now().toString().split(' ')[0];

String get currentTime => DateTime.now().toString().split(' ')[1];
