import 'package:checadordeprofesores/core/utlis/timetable_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/consts/getstorage_key.dart';
import '../../../core/utlis/cycle_utils.dart';
import '../../../core/utlis/is_conected_internet_utils.dart';
import '../../../core/utlis/print_utils.dart';

class TimetableService {
  var timetableBox = GetStorage(GetStorageKey.timetable);

  get getTimetable => timetableBox.read(cycleUtil);

  Map getBlock(String interval, String block) {
    var blockMap = getTimetable[dayOfWeek][interval];

    if (blockMap != null) {
      return blockMap[block] ?? {};
    } else {
      return {};
    }
  }

  Future<String> updateProfessorsTimetable() async {
    GetOptions fromCache = const GetOptions(source: Source.cache);
    GetOptions fromServer = const GetOptions(source: Source.server);

    bool timetableHasData = timetableBox.hasData(cycleUtil);

    var reference = FirebaseFirestore.instance
        .collection('ciclos')
        .doc(cycleUtil)
        .collection('profesores');

    var utilsBox = GetStorage(GetStorageKey.utils);
    // utilsBox.remove('lastUpdateCache');
    var lastUpdateCache = utilsBox.read('lastUpdateCache');

    if (lastUpdateCache == null || timetableHasData == false) {
      try {
        var professorsFromServer = await reference
            .orderBy(
              'lastUpdate',
              descending: true,
            )
            .get(fromServer);

        await utilsBox.write(
            'lastUpdateCache',
            (professorsFromServer.docs[0].data()['lastUpdate'] as Timestamp)
                .millisecondsSinceEpoch);

        await buildTimetable(professorsFromServer.docs);

        return 'Calendario creado';
      } catch (e) {
        return 'No se pudo crear el horario, revisa tu conexión a internet';
      }
    } else if (await isConectedInternet()) {
      try {
        var professorsFromServer = await reference
            .where(
              'lastUpdate',
              isGreaterThan:
                  Timestamp.fromMillisecondsSinceEpoch(lastUpdateCache),
            )
            .get(fromServer);

        if (professorsFromServer.docs.isNotEmpty) {
          var professorsFromCache = await reference.get(fromCache);

          await buildTimetable(professorsFromCache.docs);

          await utilsBox.write(
              'lastUpdateCache',
              (professorsFromServer.docs[0].data()['lastUpdate'] as Timestamp)
                  .millisecondsSinceEpoch);

          return 'Calendario actualizado';
        }
      } catch (e) {
        printD(e);
        return 'No se pudo actualizar el horario, revisa tu conexión a internet o intenta más tarde';
      }
    }

    return 'No hay cambios en el horario';
  }

  buildTimetable(professors) async {
    List<Map<String, dynamic>> timetable = [{}, {}, {}, {}, {}, {}, {}];

    for (var professor in professors) {
      for (var subject in professor.data()['materias'].values) {
        // printD(subject['horario']);
        String classroom = subject['aula'];
        String block = classroom.split('-')[0];
        String subjectKey = subject['clave'];

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

              starHour++;
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
