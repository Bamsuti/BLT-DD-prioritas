import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blt_dd_prioritas/data/data_simulasi.dart';
import 'package:blt_dd_prioritas/main.dart';
import 'package:blt_dd_prioritas/models/candidate_model.dart';
import 'package:blt_dd_prioritas/services/app_backend.dart';

Map<String, int> filledScores(int value) => {
      for (final criterion in criteria) criterion.code: value,
    };

Candidate sampleCandidate({
  String id = '',
  String code = 'SIM-900',
  String name = 'Calon Uji',
  String dusun = 'Dusun Uji',
}) {
  return Candidate(
    id: id,
    simulationCode: code,
    name: name,
    dusun: dusun,
    scores: filledScores(3),
  );
}

Future<void> loginAsDemo(WidgetTester tester) async {
  await tester.pumpWidget(const BLTDDApp());
  await tester.enterText(find.byKey(const Key('login-email')), AppBackend.demoEmail);
  await tester.enterText(
    find.byKey(const Key('login-password')),
    AppBackend.demoPassword,
  );
  await tester.tap(find.byKey(const Key('login-submit')));
  await tester.pumpAndSettle();
}

void main() {
  setUp(AppBackend.resetForTest);

  group('Model dan perhitungan skor', () {
    test('Terdapat tujuh kriteria dengan total bobot 100 persen', () {
      expect(criteria, hasLength(7));
      expect(criteria.map((item) => item.code).toSet(),
          {'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7'});
      expect(totalWeightPercent, 100);
    });

    test('Skor SAW berada pada rentang 0 sampai 1', () {
      for (final candidate in demoCandidates()) {
        final score = candidate.preferenceScore();
        expect(score, greaterThanOrEqualTo(0));
        expect(score, lessThanOrEqualTo(1.000001));
        expect(candidate.scoreOutOf100, closeTo(score * 100, 0.0001));
      }
    });

    test('Ranking mengurutkan skor tertinggi ke terendah', () {
      final candidates = demoCandidates();
      final ranked = rankCandidates(candidates);
      expect(ranked, hasLength(candidates.length));
      for (var index = 0; index < ranked.length - 1; index++) {
        expect(
          ranked[index].preferenceScore(),
          greaterThanOrEqualTo(ranked[index + 1].preferenceScore()),
        );
      }
      expect(ranked.first.simulationCode, 'SIM-001');
      expect(ranked.first.scoreOutOf100, closeTo(85.0, 0.001));
    });

    test('Skor sama diurutkan berdasarkan kode simulasi', () {
      final a = sampleCandidate(id: 'a', code: 'SIM-020');
      final b = sampleCandidate(id: 'b', code: 'SIM-010');
      final ranked = rankCandidates([a, b]);
      expect(ranked.map((item) => item.simulationCode).toList(),
          ['SIM-010', 'SIM-020']);
    });

    test('Serialisasi menyimpan tujuh kriteria dan data utama', () {
      final source = demoCandidates().first;
      final restored = Candidate.fromMap('doc-restored', source.toMap());
      expect(restored.id, 'doc-restored');
      expect(restored.simulationCode, source.simulationCode);
      expect(restored.name, source.name);
      expect(restored.dusun, source.dusun);
      expect(restored.scores, source.scores);
      expect(restored.scores.keys.toSet(),
          criteria.map((criterion) => criterion.code).toSet());
    });

    test('Nilai kontrak Firestore sesuai field yang didokumentasikan', () {
      final map = demoCandidates().first.toMap();
      expect(map.keys, containsAll(['idSimulasi', 'namaLabel', 'dusun', 'catatan', 'scores']));
      expect((map['scores'] as Map).keys, hasLength(7));
    });
  });

  group('Backend mode demo', () {
    test('CRUD calon tersimpan dan terhapus dari daftar', () async {
      final before = await AppBackend.getCandidates();
      final saved = await AppBackend.saveCandidate(sampleCandidate());
      expect(saved.id, isNotEmpty);

      final afterAdd = await AppBackend.getCandidates();
      expect(afterAdd, hasLength(before.length + 1));
      expect(afterAdd.any((item) => item.simulationCode == 'SIM-900'), isTrue);

      await AppBackend.deleteCandidate(saved.id);
      final afterDelete = await AppBackend.getCandidates();
      expect(afterDelete, hasLength(before.length));
    });

    test('ID simulasi duplikat ditolak', () async {
      await expectLater(
        AppBackend.saveCandidate(sampleCandidate(code: 'sim-001')),
        throwsA(isA<BackendFailure>()),
      );
    });

    test('Login demo menolak kredensial salah dan menerima akun demo', () async {
      await expectLater(
        AppBackend.signIn(AppBackend.demoEmail, 'salah123'),
        throwsA(isA<AuthFailure>()),
      );
      expect(AppBackend.hasSession, isFalse);

      await AppBackend.signIn(AppBackend.demoEmail, AppBackend.demoPassword);
      expect(AppBackend.hasSession, isTrue);

      await AppBackend.signOut();
      expect(AppBackend.hasSession, isFalse);
    });
  });

  group('Login', () {
    testWidgets('Menampilkan judul, tombol masuk, dan akun demo', (tester) async {
      await tester.pumpWidget(const BLTDDApp());
      expect(find.text('BLT-DD Prioritas'), findsOneWidget);
      expect(find.text('Masuk'), findsOneWidget);
      expect(find.textContaining('demo@blt-dd.local'), findsOneWidget);
      expect(find.text('Mode demo'), findsOneWidget);
    });

    testWidgets('Menolak email dan kata sandi kosong', (tester) async {
      await tester.pumpWidget(const BLTDDApp());
      await tester.tap(find.byKey(const Key('login-submit')));
      await tester.pumpAndSettle();
      expect(find.text('Email wajib diisi.'), findsOneWidget);
      expect(find.text('Kata sandi wajib diisi.'), findsOneWidget);
    });

    testWidgets('Menolak format email tidak valid', (tester) async {
      await tester.pumpWidget(const BLTDDApp());
      await tester.enterText(find.byKey(const Key('login-email')), 'bukan-email');
      await tester.enterText(find.byKey(const Key('login-password')), 'password123');
      await tester.tap(find.byKey(const Key('login-submit')));
      await tester.pumpAndSettle();
      expect(find.text('Masukkan format email yang valid.'), findsOneWidget);
    });

    testWidgets('Menolak kata sandi kurang dari enam karakter', (tester) async {
      await tester.pumpWidget(const BLTDDApp());
      await tester.enterText(find.byKey(const Key('login-email')), 'petugas@desa.id');
      await tester.enterText(find.byKey(const Key('login-password')), '123');
      await tester.tap(find.byKey(const Key('login-submit')));
      await tester.pumpAndSettle();
      expect(find.text('Kata sandi minimal 6 karakter.'), findsOneWidget);
    });

    testWidgets('Menampilkan pesan ketika kredensial demo salah', (tester) async {
      await tester.pumpWidget(const BLTDDApp());
      await tester.enterText(find.byKey(const Key('login-email')), 'salah@desa.id');
      await tester.enterText(find.byKey(const Key('login-password')), 'password123');
      await tester.tap(find.byKey(const Key('login-submit')));
      await tester.pumpAndSettle();
      expect(
        find.text('Mode demo aktif. Gunakan akun demo yang tertera pada halaman login.'),
        findsOneWidget,
      );
    });

    testWidgets('Login demo berhasil membuka Beranda', (tester) async {
      await loginAsDemo(tester);
      expect(find.text('Ringkasan pengelolaan calon penerima'), findsOneWidget);
      expect(find.text('Data calon'), findsOneWidget);
      expect(find.text('Kriteria'), findsOneWidget);
    });

    testWidgets('Keluar mengakhiri sesi dan kembali ke Login', (tester) async {
      await loginAsDemo(tester);
      await tester.tap(find.byTooltip('Keluar'));
      await tester.pumpAndSettle();
      expect(find.text('Masuk'), findsOneWidget);
      expect(AppBackend.hasSession, isFalse);
    });
  });

  group('Navigasi', () {
    testWidgets('NavigationRail tampil pada layar lebar dan berpindah halaman',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await loginAsDemo(tester);
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      await tester.tap(find.text('Penilaian & Prioritas'));
      await tester.pumpAndSettle();
      expect(find.text('Kriteria dan bobot demo'), findsOneWidget);

      await tester.tap(find.text('Hasil Prioritas'));
      await tester.pumpAndSettle();
      expect(find.text('Peringkat calon'), findsOneWidget);
    });

    testWidgets('NavigationBar tampil pada layar sempit', (tester) async {
      tester.view.physicalSize = const Size(420, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await loginAsDemo(tester);
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);

      await tester.tap(find.text('Data Calon'));
      await tester.pumpAndSettle();
      expect(find.text('Data calon penerima'), findsOneWidget);
    });
  });

  group('Data calon', () {
    testWidgets('Form menolak data wajib yang kosong', (tester) async {
      await loginAsDemo(tester);
      await tester.tap(find.text('Data Calon Penerima'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('add-candidate')));
      await tester.pumpAndSettle();
      expect(find.text('Tambah calon penerima'), findsOneWidget);

      await tester.tap(find.byKey(const Key('candidate-save')));
      await tester.pumpAndSettle();
      expect(find.text('ID simulasi wajib diisi.'), findsOneWidget);
      expect(find.text('Nama calon wajib diisi.'), findsOneWidget);
      expect(find.text('Dusun/kelompok wajib diisi.'), findsOneWidget);
    });

    testWidgets('Form menolak ID simulasi duplikat', (tester) async {
      await loginAsDemo(tester);
      await tester.tap(find.text('Data Calon Penerima'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add-candidate')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('candidate-code')), 'sim-001');
      await tester.enterText(find.byKey(const Key('candidate-name')), 'Calon Duplikat');
      await tester.enterText(find.byKey(const Key('candidate-dusun')), 'Dusun Uji');
      await tester.tap(find.byKey(const Key('candidate-save')));
      await tester.pumpAndSettle();
      expect(find.text('ID simulasi sudah digunakan.'), findsOneWidget);
    });

    testWidgets('Tambah dan ubah calon tercermin pada daftar', (tester) async {
      await loginAsDemo(tester);
      await tester.tap(find.text('Data Calon Penerima'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('add-candidate')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('candidate-code')), 'SIM-050');
      await tester.enterText(find.byKey(const Key('candidate-name')), 'Calon Simulasi F');
      await tester.enterText(find.byKey(const Key('candidate-dusun')), 'Dusun Contoh 4');
      await tester.tap(find.byKey(const Key('candidate-save')));
      await tester.pumpAndSettle();

      expect(find.text('Data Calon Simulasi F (SIM-050) tersimpan.'), findsOneWidget);
      final afterAdd = await AppBackend.getCandidates();
      expect(
        afterAdd.any((candidate) => candidate.simulationCode == 'SIM-050'),
        isTrue,
      );

      await tester.tap(find.byTooltip('Ubah').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('candidate-name')), 'Calon Simulasi A Revisi');
      await tester.tap(find.byKey(const Key('candidate-save')));
      await tester.pumpAndSettle();

      expect(
        find.text('Data Calon Simulasi A Revisi (SIM-001) diperbarui.'),
        findsOneWidget,
      );
      final afterEdit = await AppBackend.getCandidates();
      expect(afterEdit.first.name, 'Calon Simulasi A Revisi');
      expect(find.text('Calon Simulasi A Revisi'), findsOneWidget);
    });

    testWidgets('Hapus dapat dibatalkan lalu dikonfirmasi', (tester) async {
      await loginAsDemo(tester);
      await tester.tap(find.text('Data Calon Penerima'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Hapus').first);
      await tester.pumpAndSettle();
      expect(find.text('Hapus data calon?'), findsOneWidget);
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();
      expect(find.textContaining('SIM-001'), findsOneWidget);

      await tester.tap(find.byTooltip('Hapus').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hapus'));
      await tester.pumpAndSettle();
      expect(find.textContaining('SIM-001'), findsNothing);

      for (var i = 0; i < 4; i++) {
        await tester.tap(find.byTooltip('Hapus').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Hapus'));
        await tester.pumpAndSettle();
      }
      expect(find.text('Belum ada data'), findsOneWidget);
      expect(
        find.text('Klik "Tambah calon" untuk memasukkan data pertama.'),
        findsOneWidget,
      );
    });

    testWidgets('Nilai kriteria yang diubah memengaruhi skor', (tester) async {
      await loginAsDemo(tester);
      await tester.tap(find.text('Data Calon Penerima'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Ubah').first);
      await tester.pumpAndSettle();
      final c1 = find.byKey(const Key('candidate-score-C1'));
      await tester.ensureVisible(c1);
      await tester.pumpAndSettle();
      await tester.tap(c1);
      await tester.pumpAndSettle();
      await tester.tap(find.text('1 – Sangat rendah').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('candidate-save')));
      await tester.pumpAndSettle();

      final data = await AppBackend.getCandidates();
      expect(data.first.scores['C1'], 1);
      expect(data.first.scoreOutOf100, closeTo(69.0, 0.001));
    });
  });

  group('Mode dokumentasi', () {
    testWidgets('Halaman 6 membuka form dengan pesan validasi', (tester) async {
      await tester.pumpWidget(const BLTDDApp(screenshotPage: 6));
      await tester.pumpAndSettle();
      expect(find.text('Tambah calon penerima'), findsOneWidget);
      expect(find.text('ID simulasi wajib diisi.'), findsOneWidget);
    });
  });
}
