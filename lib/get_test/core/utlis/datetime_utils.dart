String currentHour =
    '${DateTime.now().hour}:00 - ${DateTime.now().hour + 1}:00';

void setCurrentHour() {
  currentHour = '${DateTime.now().hour}:00 - ${DateTime.now().hour + 1}:00';
}
