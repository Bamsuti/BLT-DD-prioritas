import React from 'react';
import { spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { SceneChrome } from '../components/SceneChrome';
import { colors, type SceneTiming } from '../theme';

type Props = { scene: SceneTiming; index: number; total: number };

const stories = [
  {
    code: 'US-01',
    title: 'Login petugas',
    body: 'Sebagai petugas, saya ingin login agar halaman pengelolaan hanya dibuka pengguna berwenang.',
  },
  {
    code: 'US-03',
    title: 'Tambah data calon',
    body: 'Sebagai petugas, saya ingin menambah calon agar data terkelola; ID unik, nama, dusun, dan tujuh nilai wajib.',
  },
  {
    code: 'US-05',
    title: 'Konfirmasi hapus',
    body: 'Sebagai petugas, saya ingin konfirmasi sebelum menghapus agar data tidak hilang tanpa sengaja.',
  },
  {
    code: 'US-06',
    title: 'Isi tujuh kriteria',
    body: 'Sebagai petugas, saya ingin mengisi tujuh kriteria skala 1–5 agar perbandingan konsisten.',
  },
  {
    code: 'US-07',
    title: 'Lihat peringkat',
    body: 'Sebagai petugas, saya ingin melihat peringkat agar skor dan urutan calon dapat ditinjau.',
  },
];

const priorities = [
  {
    level: 'Must · K-03, K-04, K-05, K-06',
    title: 'CRUD, validasi, penilaian, skor SAW',
    reason: 'Tanpa ini alur inti tidak berjalan; data bersih adalah dasar perhitungan.',
  },
  {
    level: 'Should · K-01, K-02, K-07, K-08',
    title: 'Login, ringkasan, responsif, status data',
    reason: 'Mendukung keamanan akses, kenyamanan perangkat, dan kejelasan status.',
  },
  {
    level: 'Rencana',
    title: 'Firebase Spark: Auth, Firestore, Hosting',
    reason: 'Penyimpanan permanen dan deploy direncanakan pada Pertemuan 9–15.',
  },
];

export const NeedsScene: React.FC<Props> = ({ scene, index, total }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  return (
    <SceneChrome scene={scene} index={index} total={total}>
      <div style={{ position: 'absolute', top: 150, left: 108, right: 108 }}>
        <div
          style={{
            fontSize: 20,
            fontWeight: 800,
            letterSpacing: 5,
            color: colors.maroon,
            textTransform: 'uppercase',
          }}
        >
          Kebutuhan & prioritas fitur
        </div>
        <div style={{ marginTop: 12, fontSize: 46, fontWeight: 800, letterSpacing: -0.7 }}>
          Lima user story utama, prioritas Must dan Should
        </div>

        <div style={{ display: 'flex', gap: 52, marginTop: 26 }}>
          <div style={{ width: 800, display: 'flex', flexDirection: 'column', gap: 12 }}>
            {stories.map((item, i) => {
              const enter = spring({
                frame: Math.max(0, frame - 8 - i * 5),
                fps,
                config: { damping: 200 },
              });
              return (
                <div
                  key={item.code}
                  style={{
                    display: 'flex',
                    gap: 18,
                    alignItems: 'flex-start',
                    padding: '17px 22px',
                    borderRadius: 16,
                    background: 'rgba(255, 251, 248, 0.86)',
                    border: `1px solid ${colors.line}`,
                    opacity: enter,
                    transform: `translateY(${(1 - enter) * 18}px)`,
                  }}
                >
                  <div
                    style={{
                      width: 74,
                      flexShrink: 0,
                      fontSize: 14,
                      fontWeight: 800,
                      color: colors.maroon,
                      letterSpacing: 0.6,
                      paddingTop: 5,
                    }}
                  >
                    {item.code}
                  </div>
                  <div>
                    <div style={{ fontSize: 24, fontWeight: 750 }}>{item.title}</div>
                    <div style={{ marginTop: 3, fontSize: 18, lineHeight: 1.4, color: colors.muted }}>
                      {item.body}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>

          <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 16 }}>
            {priorities.map((item, i) => {
              const enter = spring({
                frame: Math.max(0, frame - 18 - i * 8),
                fps,
                config: { damping: 200 },
              });
              const accent = i === 0 ? colors.maroon : i === 1 ? '#9A4A38' : colors.muted;
              return (
                <div
                  key={item.level}
                  style={{
                    padding: '22px 24px',
                    borderRadius: 18,
                    background:
                      i === 0 ? 'rgba(243, 226, 229, 0.92)' : 'rgba(255, 251, 248, 0.86)',
                    border: `1px solid ${i === 0 ? '#DDBFC5' : colors.line}`,
                    opacity: enter,
                    transform: `translateX(${(1 - enter) * 30}px)`,
                  }}
                >
                  <div
                    style={{
                      fontSize: 15,
                      fontWeight: 800,
                      letterSpacing: 1.8,
                      textTransform: 'uppercase',
                      color: accent,
                    }}
                  >
                    {item.level}
                  </div>
                  <div style={{ marginTop: 6, fontSize: 26, fontWeight: 800, lineHeight: 1.2 }}>
                    {item.title}
                  </div>
                  <div style={{ marginTop: 7, fontSize: 18, lineHeight: 1.45, color: colors.muted }}>
                    {item.reason}
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </SceneChrome>
  );
};
