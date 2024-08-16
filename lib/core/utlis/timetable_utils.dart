int get dayOfWeek => DateTime.now().weekday - 1;

String get date => DateTime.now().toString().split(' ')[0];
