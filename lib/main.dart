import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models/candidate.dart';
import 'services/app_backend.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBackend.initialize();
  runApp(const BltPrioritasApp());
}

const _brand = Color(0xFF7A1C2E);

class BltPrioritasApp extends StatefulWidget {
  const BltPrioritasApp({super.key});

  @override
  State<BltPrioritasApp> createState() => _BltPrioritasAppState();
}

class _BltPrioritasAppState extends State<BltPrioritasApp> {
  bool _signedIn = AppBackend.hasSession;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLT-DD Prioritas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _brand),
        appBarTheme: const AppBarTheme(centerTitle: false),
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      home: _signedIn
          ? AppShell(onLogout: () => setState(() => _signedIn = false))
          : LoginPage(onLoginSuccess: () => setState(() => _signedIn = true)),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLoginSuccess});
  final VoidCallback onLoginSuccess;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AppBackend.signIn(_email.text, _password.text);
      if (mounted) widget.onLoginSuccess();
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_authMessage(error.code))),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _authMessage(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Email atau kata sandi tidak sesuai.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      case 'network-request-failed':
        return 'Jaringan bermasalah. Periksa koneksi internet.';
      default:
        return 'Login gagal. Periksa akun dan konfigurasi Firebase.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;
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
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.account_balance, size: 54, color: _brand),
                      const SizedBox(height: 16),
                      Text('BLT-DD Prioritas', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      const Text('Prototipe penentuan prioritas calon penerima bantuan', textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          AppBackend.firebaseReady ? 'Mode Firebase aktif' : 'MODE DEMO — data hanya tersimpan selama aplikasi berjalan',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        key: const Key('login-email'),
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                        validator: (value) {
                          final email = (value ?? '').trim();
                          if (email.isEmpty) return 'Email wajib diisi.';
                          if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                            return 'Masukkan format email yang valid.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        key: const Key('login-password'),
                        controller: _password,
                        obscureText: _hidePassword,
                        decoration: InputDecoration(
                          labelText: 'Kata sandi',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _hidePassword = !_hidePassword),
                            icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                            tooltip: _hidePassword ? 'Tampilkan kata sandi' : 'Sembunyikan kata sandi',
                          ),
                        ),
                        validator: (value) {
                          if ((value ?? '').isEmpty) return 'Kata sandi wajib diisi.';
                          if ((value ?? '').length < 6) return 'Kata sandi minimal 6 karakter.';
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Masuk'),
                      ),
                      if (!AppBackend.firebaseReady) ...[
                        const SizedBox(height: 12),
                        const Text('Akun demo: demo@blt-dd.local\nKata sandi: demo123', textAlign: TextAlign.center),
                      ],
                      if (wide) const SizedBox(height: 4),
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

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.onLogout});
  final VoidCallback onLogout;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selected = 0;
  bool _loading = true;
  String? _loadError;
  List<Candidate> _candidates = [];

  final _titles = const ['Beranda', 'Data Calon Penerima', 'Penilaian & Prioritas', 'Hasil Prioritas'];

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
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'Data gagal dimuat. Periksa koneksi atau aturan Firestore.';
      });
    }
  }

  Future<void> _save(Candidate candidate) async {
    await AppBackend.saveCandidate(candidate);
    await _reload();
  }

  Future<void> _delete(Candidate candidate) async {
    await AppBackend.deleteCandidate(candidate.id);
    await _reload();
  }

  Future<void> _logout() async {
    await AppBackend.signOut();
    if (mounted) widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(candidates: _candidates, onNavigate: (index) => setState(() => _selected = index)),
      CandidateListPage(
        candidates: _candidates,
        onAdd: () => _openForm(),
        onEdit: (candidate) => _openForm(candidate),
        onDelete: _confirmDelete,
      ),
      ScoringPage(candidates: _candidates, onEdit: (candidate) => _openForm(candidate)),
      ResultsPage(candidates: _candidates),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selected]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(child: Chip(avatar: Icon(AppBackend.firebaseReady ? Icons.cloud_done : Icons.science, size: 16), label: Text(AppBackend.firebaseReady ? 'Firebase' : 'Demo'))),
          ),
          IconButton(tooltip: 'Keluar', onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(_loadError!),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _reload, child: const Text('Coba lagi')),
                ]))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 760) {
                      return Row(children: [
                        NavigationRail(
                          selectedIndex: _selected,
                          onDestinationSelected: (value) => setState(() => _selected = value),
                          labelType: NavigationRailLabelType.all,
                          destinations: const [
                            NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Beranda')),
                            NavigationRailDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: Text('Data Calon')),
                            NavigationRailDestination(icon: Icon(Icons.rule_outlined), selectedIcon: Icon(Icons.rule), label: Text('Penilaian')),
                            NavigationRailDestination(icon: Icon(Icons.leaderboard_outlined), selectedIcon: Icon(Icons.leaderboard), label: Text('Hasil')),
                          ],
                        ),
                        const VerticalDivider(width: 1),
                        Expanded(child: IndexedStack(index: _selected, children: pages)),
                      ]);
                    }
                    return Column(children: [
                      Expanded(child: IndexedStack(index: _selected, children: pages)),
                      NavigationBar(
                        selectedIndex: _selected,
                        onDestinationSelected: (value) => setState(() => _selected = value),
                        destinations: const [
                          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Beranda'),
                          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Data Calon'),
                          NavigationDestination(icon: Icon(Icons.rule_outlined), selectedIcon: Icon(Icons.rule), label: 'Penilaian'),
                          NavigationDestination(icon: Icon(Icons.leaderboard_outlined), selectedIcon: Icon(Icons.leaderboard), label: 'Hasil'),
                        ],
                      ),
                    ]);
                  },
                ),
      floatingActionButton: _selected == 1
          ? FloatingActionButton.extended(onPressed: () => _openForm(), icon: const Icon(Icons.add), label: const Text('Tambah calon'))
          : null,
    );
  }

  Future<void> _openForm([Candidate? existing]) async {
    await showDialog<void>(
      context: context,
      builder: (_) => CandidateFormDialog(
        existing: existing,
        allCandidates: _candidates,
        onSave: _save,
      ),
    );
  }

  Future<void> _confirmDelete(Candidate candidate) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus calon?'),
        content: Text('Data ${candidate.name} akan dihapus dari prototipe.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await _delete(candidate);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data calon dihapus.')));
      } catch (_) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data gagal dihapus.')));
      }
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.candidates, required this.onNavigate});
  final List<Candidate> candidates;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final ranked = rankCandidates(candidates);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Ringkasan aplikasi', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Gunakan data simulasi untuk mencoba alur pendataan, penilaian, dan hasil prioritas.'),
        const SizedBox(height: 16),
        Wrap(spacing: 12, runSpacing: 12, children: [
          _MetricCard(label: 'Jumlah calon', value: candidates.length.toString(), icon: Icons.people, onTap: () => onNavigate(1)),
          _MetricCard(label: 'Jumlah kriteria', value: criteria.length.toString(), icon: Icons.rule, onTap: () => onNavigate(2)),
          _MetricCard(label: 'Hasil prioritas', value: candidates.length.toString(), icon: Icons.leaderboard, onTap: () => onNavigate(3)),
        ]),
        const SizedBox(height: 20),
        const Card(child: ListTile(leading: Icon(Icons.info_outline), title: Text('Catatan prototipe'), subtitle: Text('Data dan bobot adalah simulasi. Skor tidak boleh digunakan sebagai keputusan resmi penerima bantuan.'))),
        const SizedBox(height: 20),
        Text('Pintasan', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        FilledButton.tonalIcon(onPressed: () => onNavigate(1), icon: const Icon(Icons.people), label: const Text('Kelola data calon')),
        const SizedBox(height: 8),
        FilledButton.tonalIcon(onPressed: () => onNavigate(2), icon: const Icon(Icons.rule), label: const Text('Isi penilaian')),
        const SizedBox(height: 8),
        FilledButton.tonalIcon(onPressed: () => onNavigate(3), icon: const Icon(Icons.leaderboard), label: const Text('Lihat hasil prioritas')),
        if (ranked.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Tiga skor tertinggi (simulasi)', style: Theme.of(context).textTheme.titleLarge),
          for (final candidate in ranked.take(3))
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(child: Text((ranked.indexOf(candidate) + 1).toString())),
              title: Text(candidate.name),
              subtitle: Text(candidate.dusun),
              trailing: Text((candidate.preferenceScore(candidates) * 100).toStringAsFixed(1)),
            ),
        ],
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, required this.icon, required this.onTap});
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 220,
        child: Card(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(icon, color: _brand),
                const SizedBox(height: 12),
                Text(value, style: Theme.of(context).textTheme.headlineMedium),
                Text(label),
              ]),
            ),
          ),
        ),
      );
}

class CandidateListPage extends StatelessWidget {
  const CandidateListPage({super.key, required this.candidates, required this.onAdd, required this.onEdit, required this.onDelete});
  final List<Candidate> candidates;
  final VoidCallback onAdd;
  final ValueChanged<Candidate> onEdit;
  final ValueChanged<Candidate> onDelete;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(children: [
            Expanded(child: Text('Daftar calon simulasi', style: Theme.of(context).textTheme.titleLarge)),
            OutlinedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add), label: const Text('Tambah')),
          ]),
          const SizedBox(height: 8),
          if (candidates.isEmpty)
            const Card(child: Padding(padding: EdgeInsets.all(24), child: Text('Belum ada data. Tambahkan calon untuk memulai.')))
          else
            for (final candidate in candidates)
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                  title: Text(candidate.name),
                  subtitle: Text('${candidate.simulationCode} • ${candidate.dusun}${candidate.notes.isEmpty ? '' : ' • ${candidate.notes}'}'),
                  isThreeLine: candidate.notes.isNotEmpty,
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(tooltip: 'Ubah', onPressed: () => onEdit(candidate), icon: const Icon(Icons.edit_outlined)),
                    IconButton(tooltip: 'Hapus', onPressed: () => onDelete(candidate), icon: const Icon(Icons.delete_outline)),
                  ]),
                ),
              ),
        ],
      );
}

class ScoringPage extends StatelessWidget {
  const ScoringPage({super.key, required this.candidates, required this.onEdit});
  final List<Candidate> candidates;
  final ValueChanged<Candidate> onEdit;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Kriteria dan bobot demo', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('Skala 1–5 menilai tingkat kerentanan. Nilai 5 berarti kerentanan lebih tinggi. Bobot dan interpretasi berikut hanya untuk demonstrasi, belum divalidasi.'),
          const SizedBox(height: 12),
          for (final criterion in criteria)
            Card(child: ListTile(title: Text(criterion.name), subtitle: Text(criterion.description), trailing: Text('${criterion.weightPercent}%'))),
          const SizedBox(height: 16),
          Text('Ubah penilaian calon', style: Theme.of(context).textTheme.titleLarge),
          for (final candidate in candidates)
            Card(child: ListTile(title: Text('${candidate.simulationCode} — ${candidate.name}'), subtitle: const Text('Buka formulir untuk memperbarui ketujuh nilai kriteria.'), trailing: TextButton(onPressed: () => onEdit(candidate), child: const Text('Isi nilai')))),
        ],
      );
}

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key, required this.candidates});
  final List<Candidate> candidates;

  @override
  Widget build(BuildContext context) {
    final ranked = rankCandidates(candidates);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Hasil prioritas simulasi', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Card(child: ListTile(leading: Icon(Icons.warning_amber_outlined), title: Text('Bukan keputusan resmi'), subtitle: Text('Peringkat ini hanya bahan demonstrasi teknis dan perlu validasi kriteria, bobot, data, serta musyawarah.'))),
        const SizedBox(height: 12),
        if (ranked.isEmpty)
          const Text('Belum ada calon yang dapat diperingkat.')
        else
          for (var index = 0; index < ranked.length; index++)
            Card(child: ListTile(leading: CircleAvatar(child: Text((index + 1).toString())), title: Text('${ranked[index].simulationCode} — ${ranked[index].name}'), subtitle: Text('${ranked[index].dusun} • Skor preferensi'), trailing: Text((ranked[index].preferenceScore(candidates) * 100).toStringAsFixed(2)))),
        const SizedBox(height: 12),
        const Text('Rumus demo SAW: Vᵢ = Σ(wⱼ × rᵢⱼ), rᵢⱼ = xᵢⱼ / nilai maksimum kriteria. Total bobot = 100%. Semua kriteria sementara ditafsirkan sebagai indikator kerentanan (benefit); validasi arah dan bobot masih diperlukan.'),
      ],
    );
  }
}

class CandidateFormDialog extends StatefulWidget {
  const CandidateFormDialog({super.key, this.existing, required this.allCandidates, required this.onSave});
  final Candidate? existing;
  final List<Candidate> allCandidates;
  final Future<void> Function(Candidate candidate) onSave;

  @override
  State<CandidateFormDialog> createState() => _CandidateFormDialogState();
}

class _CandidateFormDialogState extends State<CandidateFormDialog> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _simulationCode;
  late final TextEditingController _name;
  late final TextEditingController _dusun;
  late final TextEditingController _notes;
  late final Map<String, int?> _scores;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _simulationCode = TextEditingController(text: widget.existing?.simulationCode ?? '');
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _dusun = TextEditingController(text: widget.existing?.dusun ?? '');
    _notes = TextEditingController(text: widget.existing?.notes ?? '');
    _scores = {
      for (final criterion in criteria) criterion.code: widget.existing?.scores[criterion.code],
    };
  }

  @override
  void dispose() {
    _simulationCode.dispose();
    _name.dispose();
    _dusun.dispose();
    _notes.dispose();
    super.dispose();
  }

  String? _validateCode(String? value) {
    final code = (value ?? '').trim();
    if (code.isEmpty) return 'ID simulasi wajib diisi.';
    final duplicate = widget.allCandidates.any((candidate) =>
        candidate.id != widget.existing?.id &&
        candidate.simulationCode.toLowerCase() == code.toLowerCase());
    if (duplicate) return 'ID simulasi sudah digunakan.';
    return null;
  }

  Future<void> _save() async {
    if (!_key.currentState!.validate()) return;
    setState(() => _saving = true);
    final candidate = Candidate(
      id: widget.existing?.id ?? '',
      simulationCode: _simulationCode.text.trim(),
      name: _name.text.trim(),
      dusun: _dusun.text.trim(),
      notes: _notes.text.trim(),
      scores: {for (final criterion in criteria) criterion.code: _scores[criterion.code]!},
    );
    try {
      await widget.onSave(candidate);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Penyimpanan gagal. Periksa koneksi atau aturan Firestore.')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.existing == null ? 'Tambah calon simulasi' : 'Ubah data calon'),
        content: SizedBox(
          width: 560,
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(key: const Key('candidate-code'), controller: _simulationCode, decoration: const InputDecoration(labelText: 'ID simulasi *'), validator: _validateCode),
                  const SizedBox(height: 12),
                  TextFormField(key: const Key('candidate-name'), controller: _name, decoration: const InputDecoration(labelText: 'Nama/label calon *'), validator: (value) => (value ?? '').trim().isEmpty ? 'Nama calon wajib diisi.' : null),
                  const SizedBox(height: 12),
                  TextFormField(key: const Key('candidate-dusun'), controller: _dusun, decoration: const InputDecoration(labelText: 'Dusun/kelompok simulasi *'), validator: (value) => (value ?? '').trim().isEmpty ? 'Dusun/kelompok wajib diisi.' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: _notes, maxLength: 200, maxLines: 2, decoration: const InputDecoration(labelText: 'Catatan (opsional)')),
                  const SizedBox(height: 8),
                  Align(alignment: Alignment.centerLeft, child: Text('Penilaian kriteria (wajib)', style: Theme.of(context).textTheme.titleMedium)),
                  for (final criterion in criteria)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: DropdownButtonFormField<int>(
                        value: _scores[criterion.code],
                        decoration: InputDecoration(labelText: '${criterion.name} *'),
                        items: [
                          for (var value = 1; value <= 5; value++)
                            DropdownMenuItem(value: value, child: Text('$value - ${_ratingLabel(value)}')),
                        ],
                        onChanged: (value) => setState(() => _scores[criterion.code] = value),
                        validator: (value) => value == null ? 'Pilih nilai untuk ${criterion.name}.' : null,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: _saving ? null : () => Navigator.of(context).pop(), child: const Text('Batal')),
          FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? 'Menyimpan...' : 'Simpan')),
        ],
      );

  String _ratingLabel(int value) {
    switch (value) {
      case 1:
        return 'Kerentanan sangat rendah';
      case 2:
        return 'Kerentanan rendah';
      case 3:
        return 'Kerentanan sedang';
      case 4:
        return 'Kerentanan tinggi';
      default:
        return 'Kerentanan sangat tinggi';
    }
  }
}
