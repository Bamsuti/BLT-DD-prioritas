import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blt_dd_prioritas/main.dart';
import 'package:blt_dd_prioritas/models/candidate.dart';

void main() {
  testWidgets('Login menolak email kosong', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LoginPage(onLoginSuccess: () {}),
    ));
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Email wajib diisi.'), findsOneWidget);
  });

  testWidgets('Login menolak format email tidak valid', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LoginPage(onLoginSuccess: () {}),
    ));
    await tester.enterText(find.byKey(const Key('login-email')), 'bukan-email');
    await tester.enterText(find.byKey(const Key('login-password')), 'password123');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Masukkan format email yang valid.'), findsOneWidget);
  });

  test('Bobot kriteria demo berjumlah 100 persen', () {
    expect(criteria.fold<int>(0, (sum, item) => sum + item.weightPercent), 100);
  });

  test('Skor SAW demo berada dalam rentang 0 sampai 1', () {
    final candidates = demoCandidates();
    for (final candidate in candidates) {
      final score = candidate.preferenceScore(candidates);
      expect(score, greaterThanOrEqualTo(0));
      expect(score, lessThanOrEqualTo(1.000001));
    }
  });
}
