import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

import '../consts/app_keys.dart';

class UpdateCacheUtill {
  // UpdateCacheUtill._internal();

  // static final UpdateCacheUtill _instance = UpdateCacheUtill._internal();

  // factory UpdateCacheUtill() => _instance;

  final _utilsBox = GetStorage(AppKeys.UTILS);

  Future<void> saveLastUpdateCache(timestamp) async => await _utilsBox.write(
      AppKeys.UTIL_UPDATE_CACHE,
      (timestamp as Timestamp).millisecondsSinceEpoch);

  getLastUpdateCache() => _utilsBox.read(AppKeys.UTIL_UPDATE_CACHE);
}
