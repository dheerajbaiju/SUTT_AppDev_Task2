import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference bookCollection =
      FirebaseFirestore.instance.collection('book');
}
