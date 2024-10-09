import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utlis/cycle_utils.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GetOptions get fromCache => const GetOptions(source: Source.cache);
  GetOptions get fromServer => const GetOptions(source: Source.server);

  getProfessorsReference() {
    return _firestore
        .collection('ciclos')
        .doc(cycleUtil)
        .collection('profesores');
  }
}
