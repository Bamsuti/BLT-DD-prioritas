import 'package:flutter/material.dart';

import 'package:blt_dd_prioritas/core/theme.dart';
import 'package:blt_dd_prioritas/models/candidate_model.dart';

/// Kartu ringkasan yang dipakai di Beranda.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.caption,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final String caption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.maroon.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppColors.maroon),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(label, style: const TextStyle(color: AppColors.muted)),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      caption,
                      style: const TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kartu bagian dengan judul, dipakai untuk mengelompokkan konten.
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

/// Baris bobot kriteria yang dipakai di halaman Penilaian.
class WeightRow extends StatelessWidget {
  const WeightRow({super.key, required this.label, required this.weight});

  final String label;
  final String weight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            weight,
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.maroon),
          ),
        ],
      ),
    );
  }
}

/// Peringatan informasi bernuansa oranye.
class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warningBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.warningText, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip penanda mode data (demo atau Firebase).
class ModeChip extends StatelessWidget {
  const ModeChip({super.key, required this.firebaseReady});

  final bool firebaseReady;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: firebaseReady
          ? 'Aplikasi terhubung ke Firebase Authentication dan Cloud Firestore'
          : 'Mode demo: data disimpan di memori dan hilang saat aplikasi dimuat ulang',
      child: Chip(
        visualDensity: VisualDensity.compact,
        avatar: Icon(
          firebaseReady ? Icons.cloud_done_outlined : Icons.science_outlined,
          size: 16,
          color: firebaseReady ? AppColors.success : AppColors.warning,
        ),
        label: Text(
          firebaseReady ? 'Firebase' : 'Mode demo',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// Tile peringkat calon penerima.
class CandidateRankTile extends StatelessWidget {
  const CandidateRankTile({
    super.key,
    required this.rank,
    required this.candidate,
    this.showScore = true,
  });

  final int rank;
  final Candidate candidate;
  final bool showScore;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      leading: CircleAvatar(
        backgroundColor: rank == 1 ? AppColors.maroon : const Color(0xFFE2E8F0),
        foregroundColor: rank == 1 ? Colors.white : AppColors.ink,
        child: Text('$rank', style: const TextStyle(fontWeight: FontWeight.w800)),
      ),
      title: Text(candidate.name, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text('${candidate.simulationCode} · ${candidate.dusun}'),
      trailing: showScore
          ? Text(
              candidate.scoreOutOf100.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.maroon,
              ),
            )
          : null,
    );
  }
}
