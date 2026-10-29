import 'package:flutter/material.dart';

import 'package:blt_dd_prioritas/core/theme.dart';
import 'package:blt_dd_prioritas/models/candidate_model.dart';
import 'package:blt_dd_prioritas/widgets/app_widgets.dart';

/// Halaman hasil prioritas: peringkat calon berdasarkan skor demo.
class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key, required this.ranked});

  final List<Candidate> ranked;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Hasil prioritas',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Urutan dihitung dari skor simulasi tertinggi ke terendah (skala 0–100).',
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        if (ranked.isEmpty)
          const SectionCard(
            title: 'Belum ada hasil',
            child: Text('Tambahkan calon penerima dan isi nilai kriteria terlebih dahulu.'),
          )
        else
          SectionCard(
            title: 'Peringkat calon',
            child: Column(
              children: [
                for (var index = 0; index < ranked.length; index++)
                  CandidateRankTile(rank: index + 1, candidate: ranked[index]),
              ],
            ),
          ),
        const SizedBox(height: 16),
        const SectionCard(
          title: 'Cara skor dihitung',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('r = nilai kriteria ÷ 5'),
              SizedBox(height: 4),
              Text('V = Σ (bobot × r) untuk tujuh kriteria'),
              SizedBox(height: 4),
              Text('Skor akhir = V × 100'),
              SizedBox(height: 10),
              Text(
                'Contoh: calon dengan nilai 5 pada kriteria berbobot 20% menyumbang 0,20 pada skor V.',
                style: TextStyle(color: AppColors.muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const InfoBanner(
          text:
              'Hasil belum disimpan permanen dan bukan keputusan penetapan penerima. Skor tidak menggantikan verifikasi lapangan serta musyawarah desa.',
        ),
      ],
    );
  }
}
