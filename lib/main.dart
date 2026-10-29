import 'package:flutter/material.dart';

import 'package:blt_dd_prioritas/core/theme.dart';
import 'package:blt_dd_prioritas/pages/app_shell.dart';
import 'package:blt_dd_prioritas/pages/login_page.dart';
import 'package:blt_dd_prioritas/services/app_backend.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBackend.initialize();

  // Mode dokumentasi (build-time). Hanya aktif jika aplikasi dibangun dengan
  // --dart-define=SCREENSHOT_MODE=true untuk pengambilan screenshot otomatis.
  const screenshotMode = bool.fromEnvironment('SCREENSHOT_MODE');
  final page = screenshotMode
      ? int.tryParse(Uri.base.queryParameters['page'] ?? '')
      : null;

  runApp(BLTDDApp(screenshotPage: page));
}

class BLTDDApp extends StatefulWidget {
  const BLTDDApp({super.key, this.screenshotPage});

  /// Indeks halaman awal untuk mode dokumentasi:
  /// 0 = login, 1 = beranda, 2 = data calon, 3 = penilaian, 4 = hasil,
  /// 5 = dialog form, 6 = dialog form dengan validasi tampil.
  final int? screenshotPage;

  @override
  State<BLTDDApp> createState() => _BLTDDAppState();
}

class _BLTDDAppState extends State<BLTDDApp> {
  late bool _signedIn =
      widget.screenshotPage != null || AppBackend.hasSession;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLT-DD Prioritas',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    final page = widget.screenshotPage;
    if (page == null) {
      return _signedIn
          ? AppShell(onLogout: () => setState(() => _signedIn = false))
          : LoginPage(onLoginSuccess: () => setState(() => _signedIn = true));
    }
    if (page <= 0) {
      return LoginPage(onLoginSuccess: () {});
    }
    final initialIndex = page >= 5 ? 1 : (page - 1).clamp(0, 3);
    return AppShell(
      initialIndex: initialIndex,
      openCandidateDialog: page == 5 || page == 6,
      validateFormOnOpen: page == 6,
      onLogout: () {},
    );
  }
}
