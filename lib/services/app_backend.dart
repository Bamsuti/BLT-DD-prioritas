import 'dart:async';

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
  // Akun tambahan hasil pendaftaran pada mode demo; hilang saat aplikasi
  // ditutup karena tidak tersimpan di Firebase.
  static final Map<String, String> _demoAccounts = {};
  static final StreamController<bool> _sessionState =
      StreamController<bool>.broadcast();

  static bool get hasSession =>
      firebaseReady ? FirebaseAuth.instance.currentUser != null : _demoSignedIn;

  /// Kabar setiap kali status login berubah.
  ///
  /// Mode Firebase memakai `authStateChanges()` sehingga pemulihan sesi dan
  /// keluar terdeteksi otomatis. Mode demo mengirim peristiwa saat masuk atau
  /// keluar; nilai terkini dipakai sebagai `initialData` oleh pemakainya.
  static Stream<bool> sessionChanges() {
    if (firebaseReady) {
      return FirebaseAuth.instance.authStateChanges()
          .map((user) => user != null);
    }
    return _sessionState.stream;
  }

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

  /// Memproses masuk dan mengembalikan `true` bila akun baru dibuat otomatis.
  ///
  /// Firebase menyamarkan "email belum terdaftar" dan "kata sandi salah"
  /// menjadi `invalid-credential`. Karena itu setelah gagal masuk dicoba
  /// pendaftaran: bila berhasil, akun dibuat otomatis; bila ditolak dengan
  /// `email-already-in-use`, akun memang ada dan kata sandinya salah.
  /// Mode demo memakai mekanisme yang sama dengan pendaftaran akun demo.
  static Future<bool> signIn(String email, String password) async {
    if (firebaseReady) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        return false;
      } on FirebaseAuthException catch (error) {
        if (error.code != 'invalid-credential' &&
            error.code != 'user-not-found') {
          rethrow;
        }
      }
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        return true;
      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {
          throw const AuthFailure('Email atau kata sandi tidak sesuai.');
        }
        rethrow;
      }
    }
    final key = email.trim().toLowerCase();
    final stored = _demoAccounts[key];
    if (stored != null || key == demoEmail) {
      final cocok =
          key == demoEmail ? password == demoPassword : stored == password;
      if (!cocok) {
        throw const AuthFailure('Email atau kata sandi tidak sesuai.');
      }
      _demoSignedIn = true;
      _sessionState.add(true);
      return false;
    }
    // Email belum terdaftar: akun demo dibuat otomatis seperti pendaftaran.
    _demoAccounts[key] = password;
    _demoSignedIn = true;
    _sessionState.add(true);
    return true;
  }

  /// Membuat akun baru lalu langsung menganggap pengguna sudah masuk.
  ///
  /// Mode Firebase memakai pendaftaran Email/Password. Mode demo menyimpan
  /// akun simulasi di memori agar alur pendaftaran tetap dapat dicoba.
  static Future<void> register(String email, String password) async {
    if (firebaseReady) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return;
    }
    final key = email.trim().toLowerCase();
    if (key == demoEmail || _demoAccounts.containsKey(key)) {
      throw const AuthFailure('Email sudah terdaftar. Silakan masuk.');
    }
    _demoAccounts[key] = password;
    _demoSignedIn = true;
    _sessionState.add(true);
  }

  static Future<void> signOut() async {
    if (firebaseReady) {
      await FirebaseAuth.instance.signOut();
    } else {
      _demoSignedIn = false;
      _sessionState.add(false);
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
    _demoAccounts.clear();
  }
}
