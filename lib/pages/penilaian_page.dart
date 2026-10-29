import 'package:flutter/material.dart';

import 'package:blt_dd_prioritas/core/theme.dart';
import 'package:blt_dd_prioritas/models/candidate_model.dart';
import 'package:blt_dd_prioritas/widgets/app_widgets.dart';

/// Halaman penilaian & prioritas: kriteria, bobot demo, dan akses
/// memperbarui nilai calon.
class AssessmentPage extends StatelessWidget {
  const AssessmentPage({
    super.key,
    required this.candidates,
    required this.onEdit,
    required this.onShowResults,
  });

  final List<Candidate> candidates;
  final ValueChanged<Candidate> onEdit;
  final VoidCallback onShowResults;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Penilaian & prioritas',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Skor demo dihitung dari tujuh kriteria berbobot. Bobot di bawah hanya contoh dan bukan ketentuan resmi BLT-DD.',
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        SectionCard(
          title: 'Kriteria dan bobot demo',
          child: Column(
            children: [
              for (final criterion in criteria)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 34,
                        child: Text(
                          criterion.code,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.maroon,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              criterion.name,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              criterion.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${criterion.weightPercent}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.maroon,
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(),
              Row(
                children: [
                  const Expanded(
                    child: Text('Total bobot', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  Text(
                    '$totalWeightPercent%',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.maroon,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Nilai calon',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (candidates.isEmpty)
                const Text('Belum ada calon. Tambahkan data terlebih dahulu.')
              else
                for (final candidate in candidates)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.maroon.withValues(alpha: .08),
                      foregroundColor: AppColors.maroon,
                      child: const Icon(Icons.person_outline),
                    ),
                    title: Text(
                      '${candidate.simulationCode} — ${candidate.name}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(candidate.dusun),
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
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => onEdit(candidate),
                          child: const Text('Isi nilai'),
                        ),
                      ],
                    ),
                  ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: candidates.isEmpty ? null : onShowResults,
                icon: const Icon(Icons.calculate_outlined),
                label: const Text('Lihat hasil prioritas'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const InfoBanner(
          text:
              'Rumus demo SAW: V = Σ (nilai ÷ 5 × bobot). Semua kriteria sementara ditafsirkan sebagai indikator kerentanan (benefit). '
              'Urutan ini hanya demonstrasi teknis; keputusan nyata harus mengikuti aturan, verifikasi, dan musyawarah yang berlaku.',
        ),
      ],
    );
  }
}
