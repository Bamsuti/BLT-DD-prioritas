// Model data calon penerima BLT-DD beserta tujuh kriteria penilaian.
//
// Semua nilai kriteria memakai skala 1–5. Nilai lebih tinggi berarti
// tingkat kerentanan lebih tinggi (semua kriteria diperlakukan sebagai
// benefit pada perhitungan SAW demo).

class Criterion {
  const Criterion({
    required this.code,
    required this.name,
    required this.weightPercent,
    required this.description,
  });

  final String code;
  final String name;
  final int weightPercent;
  final String description;
}

/// Tujuh kriteria dari presentasi UTS. Bobot berikut hanya konfigurasi demo
/// dan belum divalidasi oleh pihak berwenang.
const criteria = <Criterion>[
  Criterion(
    code: 'C1',
    name: 'Penghasilan keluarga',
    weightPercent: 20,
    description: 'Nilai tinggi berarti penghasilan keluarga relatif lebih rendah.',
  ),
  Criterion(
    code: 'C2',
    name: 'Jumlah tanggungan',
    weightPercent: 15,
    description: 'Nilai tinggi berarti beban tanggungan lebih besar.',
  ),
  Criterion(
    code: 'C3',
    name: 'Kondisi dinding',
    weightPercent: 15,
    description: 'Nilai tinggi berarti kondisi dinding lebih rentan.',
  ),
  Criterion(
    code: 'C4',
    name: 'Kondisi lantai',
    weightPercent: 15,
    description: 'Nilai tinggi berarti kondisi lantai lebih rentan.',
  ),
  Criterion(
    code: 'C5',
    name: 'Akses air bersih',
    weightPercent: 10,
    description: 'Nilai tinggi berarti akses air bersih lebih terbatas.',
  ),
  Criterion(
    code: 'C6',
    name: 'Sumber penerangan',
    weightPercent: 10,
    description: 'Nilai tinggi berarti sumber penerangan lebih terbatas.',
  ),
  Criterion(
    code: 'C7',
    name: 'Tabungan keluarga',
    weightPercent: 15,
    description: 'Nilai tinggi berarti kemampuan menyimpan uang lebih rendah.',
  ),
];

/// Total bobot demo. Harus 100% agar skor mudah dibaca.
int get totalWeightPercent =>
    criteria.fold<int>(0, (total, criterion) => total + criterion.weightPercent);

/// Skala maksimum nilai kriteria.
const int maxCriterionScore = 5;

class Candidate {
  Candidate({
    required this.id,
    required this.simulationCode,
    required this.name,
    required this.dusun,
    this.notes = '',
    required Map<String, int> scores,
  }) : scores = Map<String, int>.unmodifiable({
          for (final criterion in criteria)
            criterion.code: (scores[criterion.code] ?? 3).clamp(1, maxCriterionScore),
        });

  /// ID dokumen internal (Firestore atau ID lokal mode demo).
  final String id;

  /// Kode sintetis yang terlihat pengguna. Bukan NIK atau identitas warga.
  final String simulationCode;
  final String name;
  final String dusun;
  final String notes;
  final Map<String, int> scores;

  Candidate copyWith({
    String? id,
    String? simulationCode,
    String? name,
    String? dusun,
    String? notes,
    Map<String, int>? scores,
  }) {
    return Candidate(
      id: id ?? this.id,
      simulationCode: simulationCode ?? this.simulationCode,
      name: name ?? this.name,
      dusun: dusun ?? this.dusun,
      notes: notes ?? this.notes,
      scores: scores ?? this.scores,
    );
  }

  /// Struktur dokumen Cloud Firestore pada koleksi `calon_penerima`.
  Map<String, dynamic> toMap() => {
        'idSimulasi': simulationCode,
        'namaLabel': name,
        'dusun': dusun,
        'catatan': notes,
        'scores': scores,
      };

  factory Candidate.fromMap(String id, Map<String, dynamic> map) {
    final rawScores = map['scores'];
    final parsed = <String, int>{};
    for (final criterion in criteria) {
      final rawValue = rawScores is Map ? rawScores[criterion.code] : null;
      final parsedValue =
          rawValue is num ? rawValue.toInt() : int.tryParse(rawValue?.toString() ?? '');
      parsed[criterion.code] = (parsedValue ?? 3).clamp(1, maxCriterionScore);
    }
    return Candidate(
      id: id,
      simulationCode: (map['idSimulasi'] ?? id).toString(),
      name: map['namaLabel']?.toString() ?? '',
      dusun: map['dusun']?.toString() ?? '',
      notes: map['catatan']?.toString() ?? '',
      scores: parsed,
    );
  }

  /// Skor preferensi SAW demo (0–1):
  /// r_ij = x_ij / 5, V_i = Σ (w_j × r_ij), total bobot = 100%.
  ///
  /// Skala 1–5 pada semua kriteria sudah memiliki arah yang sama
  /// (semakin tinggi semakin rentan), sehingga tidak perlu normalisasi
  /// tambahan terhadap nilai maksimum antarcalon.
  double preferenceScore() {
    var total = 0.0;
    for (final criterion in criteria) {
      final value = scores[criterion.code] ?? 1;
      total += (value / maxCriterionScore) * criterion.weightPercent / 100;
    }
    return total;
  }

  /// Skor pada rentang 0–100 agar lebih mudah dibaca pada halaman hasil.
  double get scoreOutOf100 => preferenceScore() * 100;
}

/// Mengurutkan calon dari skor tertinggi ke terendah.
/// Kode simulasi dipakai sebagai penentu urutan yang deterministik.
List<Candidate> rankCandidates(List<Candidate> candidates) {
  final ranked = List<Candidate>.from(candidates);
  ranked.sort((a, b) {
    final byScore = b.preferenceScore().compareTo(a.preferenceScore());
    if (byScore != 0) return byScore;
    return a.simulationCode.compareTo(b.simulationCode);
  });
  return ranked;
}
