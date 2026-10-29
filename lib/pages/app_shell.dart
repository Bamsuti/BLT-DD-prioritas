import 'package:flutter/material.dart';

import 'package:blt_dd_prioritas/core/theme.dart';
import 'package:blt_dd_prioritas/models/candidate_model.dart';
import 'package:blt_dd_prioritas/pages/beranda_page.dart';
import 'package:blt_dd_prioritas/pages/data_calon_page.dart';
import 'package:blt_dd_prioritas/pages/hasil_prioritas_page.dart';
import 'package:blt_dd_prioritas/pages/penilaian_page.dart';
import 'package:blt_dd_prioritas/services/app_backend.dart';
import 'package:blt_dd_prioritas/widgets/app_widgets.dart';

/// Kerangka aplikasi setelah login.
///
/// Menyediakan navigasi bawah (layar sempit) atau navigation rail (layar
/// lebar), memuat data dari [AppBackend], dan menangani CRUD calon.
class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    this.initialIndex = 0,
    this.openCandidateDialog = false,
    this.validateFormOnOpen = false,
    required this.onLogout,
  });

  final int initialIndex;
  final bool openCandidateDialog;
  final bool validateFormOnOpen;
  final VoidCallback onLogout;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _selected = widget.initialIndex.clamp(0, 3);
  bool _loading = true;
  String? _loadError;
  List<Candidate> _candidates = <Candidate>[];
  bool _screenshotDialogOpened = false;

  static const _titles = [
    'Beranda',
    'Data Calon Penerima',
    'Penilaian & Prioritas',
    'Hasil Prioritas',
  ];

  static const _icons = [
    Icons.dashboard_outlined,
    Icons.people_alt_outlined,
    Icons.fact_check_outlined,
    Icons.leaderboard_outlined,
  ];

  static const _shortLabels = ['Beranda', 'Data Calon', 'Penilaian', 'Hasil'];

  List<Candidate> get _ranked => rankCandidates(_candidates);

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    try {
      final data = await AppBackend.getCandidates();
      if (!mounted) return;
      setState(() {
        _candidates = data;
        _loading = false;
        _loadError = null;
      });
      _openScreenshotDialogIfNeeded();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError =
            'Data gagal dimuat. Periksa koneksi internet atau aturan Firestore.';
      });
    }
  }

  Future<void> _retry() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    await _reload();
  }

  Future<void> _saveCandidate(Candidate candidate) async {
    await AppBackend.saveCandidate(candidate);
    await _reload();
  }

  Future<void> _openForm({Candidate? existing, bool validateOnOpen = false}) async {
    await showDialog<void>(
      context: context,
      builder: (_) => CandidateDialog(
        existing: existing,
        allCandidates: _candidates,
        onSubmit: _saveCandidate,
        validateOnOpen: validateOnOpen,
      ),
    );
  }

  void _openScreenshotDialogIfNeeded() {
    if (_screenshotDialogOpened || !widget.openCandidateDialog) return;
    _screenshotDialogOpened = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _openForm(validateOnOpen: widget.validateFormOnOpen);
    });
  }

  Future<void> _confirmDelete(Candidate candidate) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus data calon?'),
        content: Text(
          'Data ${candidate.name} (${candidate.simulationCode}) akan dihapus '
          'dari daftar simulasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await AppBackend.deleteCandidate(candidate.id);
      await _reload();
      _message('Data ${candidate.name} dihapus.');
    } catch (_) {
      _message('Data gagal dihapus. Periksa koneksi atau aturan Firestore.');
    }
  }

  Future<void> _logout() async {
    try {
      await AppBackend.signOut();
    } catch (_) {
      // Sesi lokal tetap diakhiri walau pemanggilan Firebase gagal.
    }
    if (mounted) widget.onLogout();
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        candidates: _candidates,
        ranked: _ranked,
        onNavigate: (index) => setState(() => _selected = index),
      ),
      CandidatesPage(
        candidates: _candidates,
        onAdd: _openForm,
        onEdit: (candidate) => _openForm(existing: candidate),
        onDelete: _confirmDelete,
      ),
      AssessmentPage(
        candidates: _candidates,
        onEdit: (candidate) => _openForm(existing: candidate),
        onShowResults: () => setState(() => _selected = 3),
      ),
      ResultsPage(ranked: _ranked),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selected],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          ModeChip(firebaseReady: AppBackend.firebaseReady),
          IconButton(
            tooltip: 'Keluar',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _buildBody(pages),
    );
  }

  Widget _buildBody(List<Widget> pages) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 42, color: AppColors.warning),
              const SizedBox(height: 12),
              Text(_loadError!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        if (wide) {
          return Row(
            children: [
              NavigationRail(
                selectedIndex: _selected,
                onDestinationSelected: (index) => setState(() => _selected = index),
                labelType: NavigationRailLabelType.all,
                backgroundColor: Colors.white,
                indicatorColor: const Color(0xFFF6E4E8),
                destinations: [
                  for (var index = 0; index < _titles.length; index++)
                    NavigationRailDestination(
                      icon: Icon(_icons[index]),
                      label: Text(_titles[index]),
                    ),
                ],
              ),
              const VerticalDivider(width: 1, color: AppColors.border),
              Expanded(child: IndexedStack(index: _selected, children: pages)),
            ],
          );
        }
        return Column(
          children: [
            Expanded(child: IndexedStack(index: _selected, children: pages)),
            NavigationBar(
              selectedIndex: _selected,
              onDestinationSelected: (index) => setState(() => _selected = index),
              destinations: [
                for (var index = 0; index < _titles.length; index++)
                  NavigationDestination(
                    icon: Icon(_icons[index]),
                    label: _shortLabels[index],
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
