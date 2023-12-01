import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();
  final _firestore = FirebaseFirestore.instance;

  streamCollection({
    required String path,
  }) {
    return _firestore.collection(path).snapshots();
  }

  streamSubjects({
    required String year,
    required String branch,
  }) {
    return _firestore
        .collection('subjects')
        .where('year', isEqualTo: year)
        .where('branch', isEqualTo: branch)
        .snapshots();
  }

  getDocument({
    required String path,
  }) {
    return _firestore.doc(path).get();
  }

  getGroup() {
    return _firestore.collection('groups').snapshots();
  }

  getSubjects({
    required String path,
    required String year,
    required String branch,
  }) {
    return _firestore
        .collection(path)
        .where('year', isEqualTo: year)
        .where('branch', isEqualTo: branch)
        .snapshots();
  }

  setData(
      {required String path,
      required Map<String, dynamic> model,
      bool merge = true}) async {
    model['updatedAt'] = FieldValue.serverTimestamp();
    return await _firestore.doc(path).set(model, SetOptions(merge: true));
  }

  addData({required String path, required Map<String, dynamic> model}) async {
    model['createdOn'] = FieldValue.serverTimestamp();
    model['updatedAt'] = FieldValue.serverTimestamp();
    return await _firestore.collection(path).add(model);
  }

  deleteData({required String path}) async {
    final reference = _firestore.doc(path);
    return await reference.delete();
  }
}

final firestoreProvider =
    Provider<FirestoreService>((ref) => FirestoreService._());
