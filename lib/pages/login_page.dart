import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:blt_dd_prioritas/core/theme.dart';
import 'package:blt_dd_prioritas/services/app_backend.dart';
import 'package:blt_dd_prioritas/widgets/app_widgets.dart';

/// Halaman masuk dan daftar akun petugas.
///
/// Satu halaman melayani dua mode; [_modeDaftar] menentukan kolom ulangi kata
/// sandi serta aksi tombol. Memakai Firebase Authentication bila konfigurasi
/// tersedia. Tanpa konfigurasi, halaman ini menjalankan mode demo dengan akun
/// sintetis dan memberi label yang jelas bahwa ini bukan autentikasi Firebase.
/// Penggantian halaman setelah berhasil masuk ditangani pemeriksaan status
/// login pada [AppBackend.sessionChanges], bukan Navigator.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _modeDaftar = false;
  bool _showPassword = false;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      if (_modeDaftar) {
        await AppBackend.register(_email.text, _password.text);
        _showMessage('Akun berhasil dibuat. Selamat datang di BLT-DD Prioritas.');
      } else {
        await AppBackend.signIn(_email.text, _password.text);
      }
      // Halaman berganti otomatis mengikuti status login.
    } on FirebaseAuthException catch (error) {
      _showMessage(_authMessage(error.code));
    } on AuthFailure catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage(
        _modeDaftar
            ? 'Pendaftaran gagal. Periksa koneksi dan konfigurasi Firebase.'
            : 'Login gagal. Periksa koneksi dan konfigurasi Firebase.',
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toggleMode() {
    setState(() {
      _modeDaftar = !_modeDaftar;
      _confirmPassword.clear();
      _loading = false;
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _authMessage(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Email atau kata sandi tidak sesuai.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan masuk.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah, minimal 6 karakter.';
      case 'user-disabled':
        return 'Akun ini dinonaktifkan. Hubungi admin.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      case 'network-request-failed':
        return 'Jaringan bermasalah. Periksa koneksi internet.';
      case 'unauthorized-domain':
        return 'Domain ini belum diizinkan pada Firebase Authentication.';
      case 'operation-not-allowed':
        return 'Metode Email/Password belum diaktifkan di Firebase.';
      case 'invalid-api-key':
      case 'api-key-not-valid':
        return 'Konfigurasi Firebase tidak valid. Periksa API key.';
      case 'web-storage-unsupported':
        return 'Browser memblokir penyimpanan sesi. Aktifkan penyimpanan situs.';
      default:
        return 'Proses autentikasi gagal. Periksa akun dan konfigurasi Firebase.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final firebaseReady = AppBackend.firebaseReady;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 62,
                          height: 62,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.maroon.withValues(alpha: .09),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.account_balance_outlined,
                            color: AppColors.maroon,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'BLT-DD Prioritas',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _modeDaftar
                            ? 'Buat akun petugas baru untuk mengelola dan menilai calon penerima bantuan desa.'
                            : 'Prototipe pengelolaan dan penilaian calon penerima bantuan desa.',
                        style: const TextStyle(color: AppColors.muted, height: 1.45),
                      ),
                      const SizedBox(height: 20),
                      ModeChip(firebaseReady: firebaseReady),
                      const SizedBox(height: 12),
                      TextFormField(
                        key: const Key('login-email'),
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email petugas',
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                        validator: (value) {
                          final email = (value ?? '').trim();
                          if (email.isEmpty) return 'Email wajib diisi.';
                          if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                              .hasMatch(email)) {
                            return 'Masukkan format email yang valid.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        key: const Key('login-password'),
                        controller: _password,
                        obscureText: !_showPassword,
                        textInputAction: _modeDaftar
                            ? TextInputAction.next
                            : TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: 'Kata sandi',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip: _showPassword
                                ? 'Sembunyikan kata sandi'
                                : 'Tampilkan kata sandi',
                            onPressed: () =>
                                setState(() => _showPassword = !_showPassword),
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (value) {
                          final password = value ?? '';
                          if (password.isEmpty) return 'Kata sandi wajib diisi.';
                          if (password.length < 6) {
                            return 'Kata sandi minimal 6 karakter.';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          if (!_modeDaftar) _submit();
                        },
                      ),
                      if (_modeDaftar) ...[
                        const SizedBox(height: 14),
                        TextFormField(
                          key: const Key('login-confirm'),
                          controller: _confirmPassword,
                          obscureText: !_showPassword,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Ulangi kata sandi',
                            prefixIcon: Icon(Icons.lock_reset_outlined),
                          ),
                          validator: (value) {
                            if ((value ?? '').isEmpty) {
                              return 'Ulangi kata sandi wajib diisi.';
                            }
                            if (value != _password.text) {
                              return 'Ulangi kata sandi tidak sama.';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _submit(),
                        ),
                      ],
                      const SizedBox(height: 20),
                      FilledButton(
                        key: const Key('login-submit'),
                        onPressed: _loading ? null : _submit,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(_modeDaftar ? 'Daftar' : 'Masuk'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        key: const Key('login-toggle'),
                        onPressed: _loading ? null : _toggleMode,
                        child: Text(
                          _modeDaftar
                              ? 'Sudah punya akun? Masuk'
                              : 'Belum punya akun? Daftar',
                        ),
                      ),
                      if (!firebaseReady) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.warningBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.warningBorder),
                          ),
                          child: Text(
                            AppBackend.firebaseInitError == null
                                ? 'Mode demo aktif. Masuk dengan email '
                                      'demo@blt-dd.local dan kata sandi demo123, '
                                      'atau coba pendaftaran akun baru. Akun '
                                      'pendaftaran hanya tersimpan selama '
                                      'aplikasi berjalan dan bukan Firebase '
                                      'Authentication.'
                                : 'Konfigurasi Firebase gagal diinisialisasi, '
                                      'sehingga aplikasi berjalan di mode demo. '
                                      'Periksa nilai --dart-define dan domain yang '
                                      'diizinkan. Akun demo: demo@blt-dd.local / '
                                      'demo123.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: AppColors.warningText,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
