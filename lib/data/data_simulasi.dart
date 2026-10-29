import 'package:blt_dd_prioritas/models/candidate_model.dart';

/// Data simulasi calon penerima BLT-DD.
/// Semua identitas sintetis dan hanya untuk demonstrasi prototipe.
List<Candidate> demoCandidates() {
  return [
    Candidate(
      id: 'demo-001',
      simulationCode: 'SIM-001',
      name: 'Calon Simulasi A',
      dusun: 'Dusun Contoh 1',
      notes: 'Data fiktif untuk demonstrasi.',
      scores: const {'C1': 5, 'C2': 4, 'C3': 4, 'C4': 4, 'C5': 3, 'C6': 4, 'C7': 5},
    ),
    Candidate(
      id: 'demo-002',
      simulationCode: 'SIM-002',
      name: 'Calon Simulasi B',
      dusun: 'Dusun Contoh 2',
      notes: 'Data fiktif untuk demonstrasi.',
      scores: const {'C1': 3, 'C2': 3, 'C3': 2, 'C4': 3, 'C5': 3, 'C6': 2, 'C7': 3},
    ),
    Candidate(
      id: 'demo-003',
      simulationCode: 'SIM-003',
      name: 'Calon Simulasi C',
      dusun: 'Dusun Contoh 1',
      notes: 'Data fiktif untuk demonstrasi.',
      scores: const {'C1': 4, 'C2': 5, 'C3': 3, 'C4': 4, 'C5': 4, 'C6': 3, 'C7': 4},
    ),
    Candidate(
      id: 'demo-004',
      simulationCode: 'SIM-004',
      name: 'Calon Simulasi D',
      dusun: 'Dusun Contoh 3',
      notes: 'Data fiktif untuk demonstrasi.',
      scores: const {'C1': 2, 'C2': 2, 'C3': 2, 'C4': 2, 'C5': 2, 'C6': 2, 'C7': 2},
    ),
    Candidate(
      id: 'demo-005',
      simulationCode: 'SIM-005',
      name: 'Calon Simulasi E',
      dusun: 'Dusun Contoh 2',
      notes: 'Data fiktif untuk demonstrasi.',
      scores: const {'C1': 4, 'C2': 4, 'C3': 5, 'C4': 4, 'C5': 3, 'C6': 4, 'C7': 4},
    ),
  ];
}
