import 'package:flutter/material.dart';

import 'package:blt_dd_prioritas/core/theme.dart';
import 'package:blt_dd_prioritas/models/candidate_model.dart';
import 'package:blt_dd_prioritas/widgets/app_widgets.dart';

/// Halaman beranda: ringkasan data calon, kriteria, dan prioritas tertinggi.
class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.candidates,
    required this.ranked,
    required this.onNavigate,
  });

  final List<Candidate> candidates;
  final List<Candidate> ranked;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          'Ringkasan pengelolaan calon penerima',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Prototipe untuk membantu petugas mengelola data dan meninjau urutan prioritas secara lebih terstruktur.',
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 720;
            final cardWidth =
                wide ? (constraints.maxWidth - 28) / 3 : constraints.maxWidth;
            final cards = [
              SummaryCard(
                icon: Icons.people_alt_outlined,
                label: 'Data calon',
                value: '${candidates.length}',
                caption: 'Data simulasi termuat',
                onTap: () => onNavigate(1),
              ),
              SummaryCard(
                icon: Icons.fact_check_outlined,
                label: 'Kriteria',
                value: '${criteria.length}',
                caption: 'Skala penilaian 1–5',
                onTap: () => onNavigate(2),
              ),
              SummaryCard(
                icon: Icons.leaderboard_outlined,
                label: 'Hasil prioritas',
                value: '${ranked.length}',
                caption: 'Diurutkan dari skor demo',
                onTap: () => onNavigate(3),
              ),
            ];
            return Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                for (final card in cards)
                  SizedBox(width: cardWidth, child: card),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        SectionCard(
          title: 'Prioritas tertinggi (demo)',
          trailing: TextButton(
            onPressed: () => onNavigate(3),
            child: const Text('Lihat semua'),
          ),
          child: ranked.isEmpty
              ? const Text('Belum ada data. Tambahkan calon penerima terlebih dahulu.')
              : Column(
                  children: [
                    for (var index = 0; index < ranked.length && index < 3; index++)
                      CandidateRankTile(rank: index + 1, candidate: ranked[index]),
                  ],
                ),
        ),
        const SizedBox(height: 16),
        const SectionCard(
          title: 'Pintasan',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Data Calon: tambah, ubah, dan hapus data simulasi.'),
              SizedBox(height: 6),
              Text('• Penilaian: periksa kriteria, bobot demo, dan nilai calon.'),
              SizedBox(height: 6),
              Text('• Hasil Prioritas: tinjau urutan skor sebagai bahan pertimbangan.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const InfoBanner(
          text:
              'Data ini hanya contoh. Skor dan bobot perlu disepakati serta divalidasi oleh pihak berwenang sebelum digunakan untuk keputusan nyata.',
        ),
      ],
    );
  }
}
