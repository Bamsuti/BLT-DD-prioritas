import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../config/firebase_config.dart';
import '../models/candidate.dart';

/// Menggunakan Firebase saat konfigurasi tersedia; selain itu menggunakan
/// mode demo yang terpisah dan hanya menyimpan data selama aplikasi hidup.
class AppBackend {
  AppBackend._();

  static bool firebaseReady = false;
  static bool _demoSignedIn = false;
  static List<Candidate> _demoData = demoCandidates();

  static bool get hasSession =>
      firebaseReady ? FirebaseAuth.instance.currentUser != null : _demoSignedIn;

  static Future<void> initialize() async {
    if (!FirebaseConfig.isConfigured) {
      firebaseReady = false;
      return;
    }
    try {
      await Firebase.initializeApp(options: FirebaseConfig.options);
      firebaseReady = true;
    } on FirebaseException {
      firebaseReady = false;
    } catch (_) {
      firebaseReady = false;
    }
  }

  static Future<void> signIn(String email, String password) async {
    if (firebaseReady) {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return;
    }
    if (email.trim().toLowerCase() == 'demo@blt-dd.local' &&
        password == 'demo123') {
      _demoSignedIn = true;
      return;
    }
    throw Exception(
      'Mode demo aktif. Gunakan demo@blt-dd.local dengan kata sandi demo123, atau konfigurasi Firebase.',
    );
  }

  static Future<void> signOut() async {
    if (firebaseReady) {
      await FirebaseAuth.instance.signOut();
    } else {
      _demoSignedIn = false;
    }
  }

  static Future<List<Candidate>> getCandidates() async {
    if (!firebaseReady) return List<Candidate>.from(_demoData);
    final snapshot =
        await FirebaseFirestore.instance.collection('calon_penerima').get();
    return snapshot.docs
        .map((doc) => Candidate.fromMap(doc.id, doc.data()))
        .toList();
  }

  static Future<Candidate> saveCandidate(Candidate candidate) async {
    if (!firebaseReady) {
      final id = candidate.id.isEmpty
          ? 'SIM-${DateTime.now().microsecondsSinceEpoch}'
          : candidate.id;
      final saved = candidate.copyWith(id: id);
      final index = _demoData.indexWhere((item) => item.id == id);
      if (index == -1) {
        _demoData = [..._demoData, saved];
      } else {
        _demoData[index] = saved;
      }
      return saved;
    }

    final collection =
        FirebaseFirestore.instance.collection('calon_penerima');
    final doc = candidate.id.isEmpty ? collection.doc() : collection.doc(candidate.id);
    final data = candidate.toMap();
    data['updatedAt'] = FieldValue.serverTimestamp();
    if (candidate.id.isEmpty) data['createdAt'] = FieldValue.serverTimestamp();
    await doc.set(data, SetOptions(merge: true));
    return candidate.copyWith(id: doc.id);
  }

  static Future<void> deleteCandidate(String id) async {
    if (!firebaseReady) {
      _demoData = _demoData.where((item) => item.id != id).toList();
      return;
    }
    await FirebaseFirestore.instance.collection('calon_penerima').doc(id).delete();
  }
}
