import 'package:flutter/material.dart';

import 'package:blt_dd_prioritas/core/theme.dart';
import 'package:blt_dd_prioritas/models/candidate_model.dart';
import 'package:blt_dd_prioritas/services/app_backend.dart';
import 'package:blt_dd_prioritas/widgets/app_widgets.dart';

/// Halaman pengelolaan data calon penerima (Create, Read, Update, Delete).
class CandidatesPage extends StatelessWidget {
  const CandidatesPage({
    super.key,
    required this.candidates,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Candidate> candidates;
  final VoidCallback onAdd;
  final ValueChanged<Candidate> onEdit;
  final ValueChanged<Candidate> onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            const SizedBox(
              width: 420,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data calon penerima',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Tambah, ubah, atau hapus data simulasi calon penerima beserta nilai tujuh kriteria.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              key: const Key('add-candidate'),
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Tambah calon'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (candidates.isEmpty)
          const SectionCard(
            title: 'Belum ada data',
            child: Text('Klik "Tambah calon" untuk memasukkan data pertama.'),
          )
        else
          ...candidates.map(
            (candidate) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.maroon.withValues(alpha: .08),
                  foregroundColor: AppColors.maroon,
                  child: const Icon(Icons.person_outline),
                ),
                title: Text(
                  candidate.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${candidate.simulationCode} · ${candidate.dusun}'
                  '${candidate.notes.isEmpty ? '' : ' · ${candidate.notes}'}',
                ),
                isThreeLine: candidate.notes.isNotEmpty,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      candidate.scoreOutOf100.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.maroon,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Ubah',
                      onPressed: () => onEdit(candidate),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      tooltip: 'Hapus',
                      onPressed: () => onDelete(candidate),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 10),
        const InfoBanner(
          text:
              'Mode demo menyimpan perubahan di memori aplikasi saja; data akan kembali ke contoh awal saat aplikasi dimuat ulang. '
              'Aktifkan Firebase untuk penyimpanan permanen.',
        ),
      ],
    );
  }
}

/// Dialog tambah/ubah calon penerima sekaligus formulir penilaian 7 kriteria.
class CandidateDialog extends StatefulWidget {
  const CandidateDialog({
    super.key,
    this.existing,
    required this.allCandidates,
    required this.onSubmit,
    this.validateOnOpen = false,
  });

  final Candidate? existing;
  final List<Candidate> allCandidates;
  final Future<void> Function(Candidate candidate) onSubmit;

  /// Dipakai mode dokumentasi untuk memicu validasi saat dialog dibuka.
  final bool validateOnOpen;

  @override
  State<CandidateDialog> createState() => _CandidateDialogState();
}

class _CandidateDialogState extends State<CandidateDialog> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _code;
  late final TextEditingController _name;
  late final TextEditingController _dusun;
  late final TextEditingController _notes;
  late final Map<String, int> _scores;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _code = TextEditingController(text: existing?.simulationCode ?? '');
    _name = TextEditingController(text: existing?.name ?? '');
    _dusun = TextEditingController(text: existing?.dusun ?? '');
    _notes = TextEditingController(text: existing?.notes ?? '');
    _scores = {
      for (final criterion in criteria)
        criterion.code: existing?.scores[criterion.code] ?? 3,
    };
    if (widget.validateOnOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _form.currentState?.validate();
      });
    }
  }

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _dusun.dispose();
    _notes.dispose();
    super.dispose();
  }

  String? _validateCode(String? value) {
    final code = (value ?? '').trim();
    if (code.isEmpty) return 'ID simulasi wajib diisi.';
    final duplicate = widget.allCandidates.any(
      (item) =>
          item.id != widget.existing?.id &&
          item.simulationCode.toLowerCase() == code.toLowerCase(),
    );
    if (duplicate) return 'ID simulasi sudah digunakan.';
    return null;
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final candidate = Candidate(
      id: widget.existing?.id ?? '',
      simulationCode: _code.text.trim(),
      name: _name.text.trim(),
      dusun: _dusun.text.trim(),
      notes: _notes.text.trim(),
      scores: _scores,
    );
    try {
      await widget.onSubmit(candidate);
      if (mounted) Navigator.of(context).pop();
    } on BackendFailure catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('Penyimpanan gagal. Periksa koneksi atau aturan Firestore.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existing == null ? 'Tambah calon penerima' : 'Ubah calon penerima',
      ),
      content: SizedBox(
        width: 560,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  key: const Key('candidate-code'),
                  controller: _code,
                  decoration: const InputDecoration(
                    labelText: 'ID simulasi *',
                    helperText: 'Contoh: SIM-006. Bukan NIK atau identitas warga.',
                  ),
                  validator: _validateCode,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('candidate-name'),
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Nama/label calon *'),
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? 'Nama calon wajib diisi.'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('candidate-dusun'),
                  controller: _dusun,
                  decoration:
                      const InputDecoration(labelText: 'Dusun/kelompok simulasi *'),
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? 'Dusun/kelompok wajib diisi.'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('candidate-notes'),
                  controller: _notes,
                  maxLength: 200,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Catatan (opsional)'),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Penilaian 7 kriteria (skala 1–5)',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 4),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nilai 5 berarti kondisi lebih rentan. Nilai awal 3, ubah bila perlu.',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ),
                const SizedBox(height: 10),
                ...criteria.map(
                  (criterion) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DropdownButtonFormField<int>(
                      key: Key('candidate-score-${criterion.code}'),
                      initialValue: _scores[criterion.code],
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: criterion.name,
                        helperText: criterion.description,
                        helperMaxLines: 2,
                      ),
                      items: [
                        for (var value = 1; value <= maxCriterionScore; value++)
                          DropdownMenuItem(
                            value: value,
                            child: Text('$value – ${_ratingLabel(value)}'),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _scores[criterion.code] = value);
                        }
                      },
                      validator: (value) =>
                          value == null ? 'Pilih nilai untuk ${criterion.name}.' : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          key: const Key('candidate-cancel'),
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const Key('candidate-save'),
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Menyimpan...' : 'Simpan'),
        ),
      ],
    );
  }

  String _ratingLabel(int value) {
    switch (value) {
      case 1:
        return 'Sangat rendah';
      case 2:
        return 'Rendah';
      case 3:
        return 'Sedang';
      case 4:
        return 'Tinggi';
      default:
        return 'Sangat tinggi';
    }
  }
}
