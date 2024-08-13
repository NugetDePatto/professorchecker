import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/consts/getstorage_key.dart';
import '../../../core/utlis/cycle_utils.dart';
import '../../../core/utlis/is_conected_internet_utils.dart';
import '../../../core/utlis/print_utils.dart';

class TimetableService {
  GetStorage timetableBox = GetStorage(GetStorageKey.timetable);

  void updateProfessorsTimetable() async {
    GetOptions fromCache = const GetOptions(source: Source.cache);
    GetOptions fromServer = const GetOptions(source: Source.server);

    bool timetableHasData =
        GetStorage(GetStorageKey.timetable).hasData(cycleUtil);

    var reference = FirebaseFirestore.instance
        .collection('ciclos')
        .doc(cycleUtil)
        .collection('profesores');

    var utilsBox = GetStorage(GetStorageKey.utils);
    var lastUpdateCache = utilsBox.read('lastUpdateCache');

    if (lastUpdateCache == null || timetableHasData == false) {
      var professorsFromServer = await reference
          .orderBy(
            'lastUpdate',
            descending: true,
          )
          .get(fromServer);

      await utilsBox.write('latestProfessorsUpdate',
          professorsFromServer.docs[0].data()['lastUpdate']);

      // aqui estaria lo de creear calendario con los datos de los profesores del server
    } else if (await isConectedInternet()) {
      try {
        var professorsFromServer = await reference
            .where(
              'lastUpdate',
              isGreaterThan: lastUpdateCache,
            )
            .get(fromServer);

        bool isUpdatedProfessor = professorsFromServer.docs.isNotEmpty;

        if (isUpdatedProfessor) {
          var professorsFromCache = await reference.get(fromCache);
          // aqui estaria lo de creear calendario con los datos de los profesores del cache
          printD(professorsFromCache.docs.length);

          await utilsBox.write('lastUpdateCache',
              professorsFromServer.docs[0].data()['lastUpdate']);
        }
      } catch (e) {
        printD(e);
      }
    }
  }

  void buildTimetable(var professors) async {
    List<Map<String, dynamic>> timetable = [{}, {}, {}, {}, {}, {}, {}];

    for (var professor in professors) {
      for (var subject in professor.data()['materias'].values) {
        String classroom = subject['aula'];
        String block = classroom.split('-')[0];

        String subjectKey = '${subject['grupo']}${subject['clave']}';

        for (int day = 0; day < 7; day++) {
          String interval = subject['horario'][day];
          if (interval.contains(':')) {
            int starHour = int.parse(interval.split(':')[0]);
            int endHour = int.parse(interval.split('-')[1].split(':')[0]);
            while (starHour < endHour) {
              interval = '$starHour:00 - ${starHour + 1}:00';

              timetable[day].putIfAbsent(interval, () => {});
              timetable[day][interval].putIfAbsent(block, () => {});
              timetable[day][interval][block].putIfAbsent(classroom, () => {});
              timetable[day][interval][block][classroom][subjectKey] = subject;
            }
          }
        }
      }
    }

    await timetableBox.write(cycleUtil, timetable);
  }

  void addInterval(
      int day, var subject, String interval, String classroom) async {
    List<dynamic> timetable = timetableBox.read(cycleUtil);

    var block = classroom.split('-')[0];
    var subjectKey = subject['grupo'] + subject['clave'];

    int starHour = int.parse(interval.split(':')[0]);
    int endHour = int.parse(interval.split('-')[1].split(':')[0]);

    while (starHour < endHour) {
      interval = '$starHour:00 - ${starHour + 1}:00';
      timetable[day].putIfAbsent(interval, () => {});
      timetable[day][interval].putIfAbsent(block, () => {});
      timetable[day][interval][block].putIfAbsent(classroom, () => {});
      timetable[day][interval][block][classroom][subjectKey] = subject;
    }

    await timetableBox.write(cycleUtil, timetable);
  }

  void removeInterval(
      int day, var subject, String interval, String classroom) async {
    List<dynamic> timetable = timetableBox.read(cycleUtil);

    var block = classroom.split('-')[0];
    var subjectKey = subject['grupo'] + subject['clave'];

    int starHour = int.parse(interval.split(':')[0]);
    int endHour = int.parse(interval.split('-')[1].split(':')[0]);

    while (starHour < endHour) {
      interval = '$starHour:00 - ${starHour + 1}:00';
      timetable[day].putIfAbsent(interval, () => {});
      timetable[day][interval].putIfAbsent(block, () => {});
      timetable[day][interval][block].putIfAbsent(classroom, () => {});
      timetable[day][interval][block][classroom][subjectKey] = subject;
    }

    await timetableBox.write(cycleUtil, timetable);
  }
}
