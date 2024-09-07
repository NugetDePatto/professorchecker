import 'package:checadordeprofesores/core/utlis/cycle_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
