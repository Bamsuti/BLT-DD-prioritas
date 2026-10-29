import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../config/firebase_config.dart';
import '../data/data_simulasi.dart';
import '../models/candidate_model.dart';

/// Kegagalan autentikasi yang dapat ditampilkan langsung kepada pengguna.
class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Kegagalan operasi data yang dapat ditampilkan langsung kepada pengguna.
class BackendFailure implements Exception {
  const BackendFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Satu pintu akses data aplikasi.
///
/// Firebase hanya dipakai jika `FirebaseConfig` tersedia dan inisialisasi
/// berhasil. Tanpa konfigurasi, aplikasi berjalan dalam mode demo dengan
/// penyimpanan di memori dan akun demo yang terpisah dari Firebase
/// Authentication.
class AppBackend {
  AppBackend._();

  static const demoEmail = 'demo@blt-dd.local';
  static const demoPassword = 'demo123';

  static bool firebaseReady = false;
  static String? firebaseInitError;
  static bool _demoSignedIn = false;
  static List<Candidate> _demoData = demoCandidates();

  static bool get hasSession =>
      firebaseReady ? FirebaseAuth.instance.currentUser != null : _demoSignedIn;

  static Future<void> initialize() async {
    firebaseInitError = null;
    if (!FirebaseConfig.isConfigured) {
      firebaseReady = false;
      return;
    }
    try {
      await Firebase.initializeApp(options: FirebaseConfig.options);
      // Tunggu pemulihan sesi tersimpan agar pengguna tidak terlempar ke
      // halaman login setiap kali aplikasi dimuat ulang.
      await FirebaseAuth.instance.authStateChanges().first;
      firebaseReady = true;
    } catch (error) {
      firebaseReady = false;
      firebaseInitError = error.toString();
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
    if (email.trim().toLowerCase() == demoEmail && password == demoPassword) {
      _demoSignedIn = true;
      return;
    }
    throw const AuthFailure(
      'Mode demo aktif. Gunakan akun demo yang tertera pada halaman login.',
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
      final duplicate = _demoData.any(
        (item) =>
            item.simulationCode.toLowerCase() ==
                candidate.simulationCode.trim().toLowerCase() &&
            item.id != candidate.id,
      );
      if (duplicate) {
        throw const BackendFailure('ID simulasi sudah digunakan.');
      }
      final id = candidate.id.isEmpty
          ? 'demo-${DateTime.now().microsecondsSinceEpoch}'
          : candidate.id;
      final saved = candidate.copyWith(id: id);
      final index = _demoData.indexWhere((item) => item.id == id);
      _demoData = index == -1
          ? [..._demoData, saved]
          : ([..._demoData]..[index] = saved);
      return saved;
    }

    final collection = FirebaseFirestore.instance.collection('calon_penerima');
    final doc =
        candidate.id.isEmpty ? collection.doc() : collection.doc(candidate.id);
    final data = candidate.toMap();
    data['updatedAt'] = FieldValue.serverTimestamp();
    if (candidate.id.isEmpty) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    await doc.set(data, SetOptions(merge: true));
    return candidate.copyWith(id: doc.id);
  }

  static Future<void> deleteCandidate(String id) async {
    if (!firebaseReady) {
      _demoData = _demoData.where((item) => item.id != id).toList();
      return;
    }
    await FirebaseFirestore.instance
        .collection('calon_penerima')
        .doc(id)
        .delete();
  }

  /// Mengembalikan data dan status sesi ke kondisi awal.
  /// Dipakai pengujian agar setiap kasus uji berdiri sendiri.
  static void resetForTest() {
    firebaseReady = false;
    firebaseInitError = null;
    _demoSignedIn = false;
    _demoData = demoCandidates();
  }
}
