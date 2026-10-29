import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blt_dd_prioritas/main.dart';
import 'package:blt_dd_prioritas/models/candidate.dart';

void main() {
  testWidgets('Login menolak email kosong', (tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage(onLoginSuccess: () {})));
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Email wajib diisi.'), findsOneWidget);
  });

  testWidgets('Login menolak format email tidak valid', (tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage(onLoginSuccess: () {})));
    await tester.enterText(find.byKey(const Key('login-email')), 'bukan-email');
    await tester.enterText(find.byKey(const Key('login-password')), 'password123');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Masukkan format email yang valid.'), findsOneWidget);
  });

  testWidgets('Form calon menolak nama kosong', (tester) async {
    var saved = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CandidateFormDialog(
          allCandidates: const [],
          onSave: (candidate) async { saved = true; },
        ),
      ),
    ));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Nama calon wajib diisi.'), findsOneWidget);
    expect(saved, isFalse);
  });

  test('Bobot kriteria demo berjumlah tepat 100 persen', () {
    expect(criteria.fold<int>(0, (sum, item) => sum + item.weightPercent), 100);
  });

  test('Ranking menghitung skor dari nilai dan urut tertinggi ke terendah', () {
    final candidates = demoCandidates();
    final ranked = rankCandidates(candidates);
    expect(ranked, isNotEmpty);
    for (var i = 0; i < ranked.length - 1; i++) {
      expect(
        ranked[i].preferenceScore(candidates),
        greaterThanOrEqualTo(ranked[i + 1].preferenceScore(candidates)),
      );
    }
    expect(ranked.first.simulationCode, 'SIM-001');
  });

  test('Skor SAW demo berada dalam rentang 0 sampai 1', () {
    final candidates = demoCandidates();
    for (final candidate in candidates) {
      final score = candidate.preferenceScore(candidates);
      expect(score, greaterThanOrEqualTo(0));
      expect(score, lessThanOrEqualTo(1.000001));
    }
  });

  test('Model serialisasi menyimpan tujuh kriteria', () {
    final source = demoCandidates().first;
    final restored = Candidate.fromMap('doc-restored', source.toMap());
    expect(restored.simulationCode, source.simulationCode);
    expect(restored.name, source.name);
    expect(restored.scores.keys.toSet(), criteria.map((c) => c.code).toSet());
  });
}
