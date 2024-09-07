import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/consts/app_strings.dart';
import '../../../core/consts/app_keys.dart';
import '../../../core/utlis/cycle_utils.dart';
import '../../../core/utlis/is_conected_internet_utils.dart';
import '../../../core/utlis/update_cache_utill.dart';
import 'firestore_service.dart';

class TimetableService {
  FirestoreService firestoreService = FirestoreService();

  final _timetableBox = GetStorage(AppKeys.timetable);

  get getTimetable => _timetableBox.read(cycleUtil);

  Map getBlock(String interval, String block, int day) {
    var blockMap = getTimetable[day][interval] ?? {};

    return _sortBlock(blockMap[block] ?? {});
  }

  Map _sortBlock(Map blockMap) {
    Map blockMapSorted = {};

    for (var classroom in blockMap.keys.toList()..sort()) {
      blockMapSorted[classroom] = blockMap[classroom];
    }

    return blockMapSorted;
  }

  Future<String> updateProfessorsTimetable() async {
    bool timetableHasData = _timetableBox.hasData(cycleUtil);

    var lastUpdateCache = UpdateCacheUtill().getLastUpdateCache();

    if (await isConnectedToInternet()) {
      if (lastUpdateCache == null || timetableHasData == false) {
        return await _createNewTimetable();
      } else {
        return await _updateTimetableIfNeeded(lastUpdateCache);
      }
    } else {
      return AppStrings.noInternetConnection;
    }
  }

  Future<String> _createNewTimetable() async {
    var professorsFromServer = await firestoreService
        .getProfessorsReference()
        .orderBy(
          AppKeys.utilsUpdateCache,
          descending: true,
        )
        .get(firestoreService.fromServer);

    await _buildTimetable(professorsFromServer.docs);

    await UpdateCacheUtill().saveLastUpdateCache(
        professorsFromServer.docs[0].data()[AppKeys.utilsUpdateCache]);

    return AppStrings.timetableCreated;
  }

  Future<String> _updateTimetableIfNeeded(lastUpdateCache) async {
    var professorsFromServer = await firestoreService
        .getProfessorsReference()
        .where(
          AppKeys.utilsUpdateCache,
          isGreaterThan: Timestamp.fromMillisecondsSinceEpoch(lastUpdateCache),
        )
        .get(FirestoreService().fromServer);

    if (professorsFromServer.docs.isNotEmpty) {
      var professorsFromCache = await firestoreService
          .getProfessorsReference()
          .get(FirestoreService().fromCache);

      await _buildTimetable(professorsFromCache.docs);

      await UpdateCacheUtill().saveLastUpdateCache(
          professorsFromServer.docs[0].data()[AppKeys.utilsUpdateCache]);

      return AppStrings.timetableUpdated;
    } else {
      return AppStrings.noUpdates;
    }
  }

  _buildTimetable(professors) async {
    List<Map<String, dynamic>> timetable = [{}, {}, {}, {}, {}, {}, {}];

    for (var professor in professors) {
      for (var subject in professor.data()['materias'].values) {
        String classroom = subject['aula'].toString().split('-')[1];
        String block = subject['aula'].toString().split('-')[0];
        String subjectKey = subject['clave'];

        for (int day = 0; day < 7; day++) {
          String interval = subject['horario'][day];
          if (interval.contains(':')) {
            _addInterval(timetable, day, interval, block, classroom, subjectKey,
                subject);
          }
        }
      }
    }

    await _timetableBox.write(cycleUtil, timetable);
  }

  void _addInterval(var timetable, int day, String interval, String block,
      String classroom, String subjectKey, var subject) {
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
