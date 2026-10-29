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

/// Bobot dan deskripsi berikut hanya konfigurasi demo untuk pengujian aplikasi.
const criteria = <Criterion>[
  Criterion(code: 'C1', name: 'Penghasilan keluarga', weightPercent: 20, description: 'Nilai tinggi berarti penghasilan relatif lebih rendah/rentan.'),
  Criterion(code: 'C2', name: 'Jumlah tanggungan', weightPercent: 15, description: 'Nilai tinggi berarti beban tanggungan lebih besar.'),
  Criterion(code: 'C3', name: 'Kondisi dinding', weightPercent: 15, description: 'Nilai tinggi berarti kondisi dinding lebih rentan.'),
  Criterion(code: 'C4', name: 'Kondisi lantai', weightPercent: 15, description: 'Nilai tinggi berarti kondisi lantai lebih rentan.'),
  Criterion(code: 'C5', name: 'Akses air bersih', weightPercent: 10, description: 'Nilai tinggi berarti akses air bersih lebih terbatas.'),
  Criterion(code: 'C6', name: 'Sumber penerangan', weightPercent: 10, description: 'Nilai tinggi berarti sumber penerangan lebih terbatas.'),
  Criterion(code: 'C7', name: 'Tabungan keluarga', weightPercent: 15, description: 'Nilai tinggi berarti kemampuan menyimpan uang lebih rendah.'),
];

class Candidate {
  const Candidate({
    required this.id,
    required this.name,
    required this.dusun,
    this.simulationCode = '',
    this.notes = '',
    required this.scores,
  });

  /// ID dokumen internal (Firestore atau ID lokal demo).
  final String id;
  /// ID simulasi yang bisa dilihat pengguna; bukan NIK atau identitas warga.
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

  Map<String, dynamic> toMap() => {
        'idSimulasi': simulationCode,
        'namaLabel': name,
        'dusun': dusun,
        'catatan': notes,
        'scores': scores,
      };

  factory Candidate.fromMap(String id, Map<String, dynamic> map) {
    final rawScores = map['scores'];
    final parsedScores = <String, int>{};
    if (rawScores is Map) {
      for (final criterion in criteria) {
        final value = rawScores[criterion.code];
        parsedScores[criterion.code] = value is num
            ? value.toInt()
            : int.tryParse(value?.toString() ?? '') ?? 3;
      }
    }
    for (final criterion in criteria) {
      parsedScores.putIfAbsent(criterion.code, () => 3);
    }
    return Candidate(
      id: id,
      simulationCode: map['idSimulasi']?.toString() ?? id,
      name: map['namaLabel']?.toString() ?? '',
      dusun: map['dusun']?.toString() ?? '',
      notes: map['catatan']?.toString() ?? '',
      scores: parsedScores,
    );
  }

  /// Normalisasi SAW demo: semua skor mengukur tingkat kerentanan sehingga
  /// diperlakukan sebagai benefit (nilai yang lebih tinggi = prioritas lebih
  /// tinggi). Interpretasi dan bobot perlu divalidasi sebelum dipakai nyata.
  double preferenceScore(List<Candidate> alternatives) {
    if (alternatives.isEmpty) return 0;
    var total = 0.0;
    for (final criterion in criteria) {
      var maxValue = 0;
      for (final alternative in alternatives) {
        final value = alternative.scores[criterion.code] ?? 0;
        if (value > maxValue) maxValue = value;
      }
      if (maxValue > 0) {
        final normalized = (scores[criterion.code] ?? 0) / maxValue;
        total += normalized * criterion.weightPercent / 100;
      }
    }
    return total;
  }
}

List<Candidate> demoCandidates() => [
      const Candidate(id: 'doc-demo-001', simulationCode: 'SIM-001', name: 'Calon Simulasi A', dusun: 'Dusun Contoh 1', notes: 'Data fiktif untuk demonstrasi.', scores: {'C1': 5, 'C2': 4, 'C3': 4, 'C4': 4, 'C5': 3, 'C6': 4, 'C7': 5}),
      const Candidate(id: 'doc-demo-002', simulationCode: 'SIM-002', name: 'Calon Simulasi B', dusun: 'Dusun Contoh 2', notes: 'Data fiktif untuk demonstrasi.', scores: {'C1': 4, 'C2': 3, 'C3': 3, 'C4': 4, 'C5': 4, 'C6': 3, 'C7': 4}),
      const Candidate(id: 'doc-demo-003', simulationCode: 'SIM-003', name: 'Calon Simulasi C', dusun: 'Dusun Contoh 1', notes: 'Data fiktif untuk demonstrasi.', scores: {'C1': 3, 'C2': 5, 'C3': 4, 'C4': 3, 'C5': 3, 'C6': 4, 'C7': 3}),
      const Candidate(id: 'doc-demo-004', simulationCode: 'SIM-004', name: 'Calon Simulasi D', dusun: 'Dusun Contoh 3', notes: 'Data fiktif untuk demonstrasi.', scores: {'C1': 4, 'C2': 4, 'C3': 2, 'C4': 3, 'C5': 4, 'C6': 3, 'C7': 2}),
      const Candidate(id: 'doc-demo-005', simulationCode: 'SIM-005', name: 'Calon Simulasi E', dusun: 'Dusun Contoh 2', notes: 'Data fiktif untuk demonstrasi.', scores: {'C1': 5, 'C2': 2, 'C3': 3, 'C4': 3, 'C5': 2, 'C6': 3, 'C7': 4}),
    ];

/// Menghasilkan ranking deterministik berdasarkan skor tertinggi ke terendah.
/// Kode simulasi menjadi tie-breaker jika dua skor bernilai sama.
List<Candidate> rankCandidates(List<Candidate> candidates) {
  final ranked = List<Candidate>.from(candidates);
  ranked.sort((a, b) {
    final byScore = b.preferenceScore(candidates).compareTo(a.preferenceScore(candidates));
    if (byScore != 0) return byScore;
    return a.simulationCode.compareTo(b.simulationCode);
  });
  return ranked;
}
