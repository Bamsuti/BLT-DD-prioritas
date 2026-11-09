import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:blt_dd_prioritas/core/theme.dart';
import 'package:blt_dd_prioritas/services/app_backend.dart';
import 'package:blt_dd_prioritas/widgets/app_widgets.dart';

/// Warna kartu krem khas halaman masuk bergaya WeFight.
const Color _kartuKrem = Color(0xFFF7ECDD);

/// Pesan kesalahan autentikasi yang mudah dipahami petugas.
String _pesanAuth(String code) {
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

/// Pesan khusus aliran atur ulang; email belum terdaftar lebih berguna
/// diberitahukan langsung daripada disembunyikan.
String _pesanReset(String code) {
  if (code == 'user-not-found') return 'Email ini belum terdaftar.';
  return _pesanAuth(code);
}

/// Dekorasi kolom isian putih tanpa garis tepi, mengikuti gaya WeFight.
InputDecoration _dekorasiLogin(String label) {
  const radius = BorderRadius.all(Radius.circular(14));
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    border: const OutlineInputBorder(
        borderRadius: radius, borderSide: BorderSide.none),
    enabledBorder: const OutlineInputBorder(
        borderRadius: radius, borderSide: BorderSide.none),
    focusedBorder: const OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: AppColors.maroon, width: 1.6),
    ),
  );
}

/// Halaman masuk dan daftar akun petugas.
///
/// Satu halaman melayani dua mode; [_modeDaftar] menentukan judul, kolom
/// ulangi kata sandi, serta aksi tombol. Memakai Firebase Authentication
/// bila konfigurasi tersedia; tanpa konfigurasi berjalan mode demo dengan
/// akun sintetis. Penggantian halaman setelah berhasil masuk ditangani
/// pemeriksaan status login pada [AppBackend.sessionChanges], bukan Navigator.
///
/// Masuk dengan email yang belum terdaftar langsung membuatkan akun otomatis
/// oleh [AppBackend.signIn], sehingga tidak ada kotak informasi akun demo.
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
        final akunBaru = await AppBackend.signIn(_email.text, _password.text);
        if (akunBaru) {
          _showMessage(
            'Email belum terdaftar, jadi akun dibuat otomatis. Gunakan kata '
            'sandi yang sama saat masuk berikutnya.',
          );
        }
      }
      // Halaman berganti otomatis mengikuti status login.
    } on FirebaseAuthException catch (error) {
      _showMessage(_pesanAuth(error.code));
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

  /// Dialog atur ulang kata sandi. Firebase mengirim tautan ke email;
  /// mode demo tidak memiliki layanan email sehingga dijelaskan apa adanya.
  Future<void> _showResetDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _DialogResetSandi(
        onMessage: _showMessage,
        initialEmail: _email.text,
      ),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final firebaseReady = AppBackend.firebaseReady;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF43131B), AppColors.maroonDark, AppColors.maroon],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.account_balance_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          'BLT-DD Prioritas',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    _modeDaftar ? 'Buat akun' : 'Login',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _modeDaftar
                        ? 'Buat akun petugas baru untuk mengelola dan menilai '
                            'calon penerima bantuan desa.'
                        : 'Prototipe pengelolaan dan penilaian calon penerima '
                            'bantuan desa.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .75),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ModeChip(firebaseReady: firebaseReady),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: _kartuKrem,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .18),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            key: const Key('login-email'),
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: _dekorasiLogin('Email petugas'),
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
                            decoration: _dekorasiLogin('Kata sandi').copyWith(
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
                                  color: AppColors.muted,
                                ),
                              ),
                            ),
                            validator: (value) {
                              final password = value ?? '';
                              if (password.isEmpty) {
                                return 'Kata sandi wajib diisi.';
                              }
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
                              decoration: _dekorasiLogin('Ulangi kata sandi'),
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
                          ] else
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                key: const Key('login-forgot'),
                                onPressed: _loading ? null : _showResetDialog,
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.maroon,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                child: const Text('Lupa kata sandi?'),
                              ),
                            ),
                          const SizedBox(height: 16),
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _modeDaftar ? 'Sudah punya akun?' : 'Belum punya akun?',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .85),
                        ),
                      ),
                      TextButton(
                        key: const Key('login-toggle'),
                        onPressed: _loading ? null : _toggleMode,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        child: Text(_modeDaftar ? 'Masuk' : 'Daftar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dialog atur ulang kata sandi.
///
/// Memiliki state sendiri agar controller email dibuang saat dialog
/// benar-benar terlepas dari pohon widget, bukan saat animasi keluar
/// masih berjalan.
class _DialogResetSandi extends StatefulWidget {
  const _DialogResetSandi({required this.onMessage, this.initialEmail = ''});

  final void Function(String message) onMessage;
  final String initialEmail;

  @override
  State<_DialogResetSandi> createState() => _DialogResetSandiState();
}

class _DialogResetSandiState extends State<_DialogResetSandi> {
  final _form = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.initialEmail);
  bool _mengirim = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _kirim() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _mengirim = true);
    final email = _email.text.trim();
    try {
      if (AppBackend.firebaseReady) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        if (!mounted) return;
        Navigator.of(context).pop();
        widget.onMessage(
          'Tautan atur ulang kata sandi telah dikirim ke $email. Periksa '
          'kotak masuk atau folder spam.',
        );
      } else {
        Navigator.of(context).pop();
        widget.onMessage(
          'Mode demo tidak dapat mengirim email karena akun hanya tersimpan '
          'sementara di memori. Tautan atur ulang aktif saat aplikasi '
          'terhubung ke Firebase.',
        );
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) setState(() => _mengirim = false);
      widget.onMessage(_pesanReset(error.code));
    } catch (_) {
      if (mounted) setState(() => _mengirim = false);
      widget.onMessage('Pengiriman tautan gagal. Periksa koneksi internet.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Atur ulang kata sandi'),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan email akun. Tautan pengaturan ulang kata sandi akan '
              'dikirim ke email tersebut.',
              style: TextStyle(height: 1.4),
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: const Key('reset-email'),
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              decoration: _dekorasiLogin('Email petugas'),
              validator: (value) {
                final email = (value ?? '').trim();
                if (email.isEmpty) return 'Email wajib diisi.';
                if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                  return 'Masukkan format email yang valid.';
                }
                return null;
              },
              onFieldSubmitted: (_) => _kirim(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _mengirim ? null : () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const Key('reset-submit'),
          onPressed: _mengirim ? null : _kirim,
          child: _mengirim
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Kirim'),
        ),
      ],
    );
  }
}
