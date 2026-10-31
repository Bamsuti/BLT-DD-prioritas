import React from 'react';
import { spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { SceneChrome } from '../components/SceneChrome';
import { colors, type SceneTiming } from '../theme';

type Props = { scene: SceneTiming; index: number; total: number };

const needs = [
  {
    code: 'K-01',
    title: 'Login petugas',
    body: 'Membatasi akses ke pengguna berwenang dan menampilkan pesan gagal.',
  },
  {
    code: 'K-02',
    title: 'Pengelolaan data calon',
    body: 'Tambah, lihat, ubah, dan hapus data dengan konfirmasi.',
  },
  {
    code: 'K-03',
    title: 'Validasi formulir',
    body: 'Kolom wajib, ID unik, dan tujuh nilai kriteria diperiksa sebelum simpan.',
  },
  {
    code: 'K-04',
    title: 'Penilaian tujuh kriteria',
    body: 'Skala 1–5 yang konsisten untuk C1 sampai C7.',
  },
  {
    code: 'K-05',
    title: 'Skor SAW dan tampilan responsif',
    body: 'Pengurutan otomatis, Web dan Android dari satu basis kode.',
  },
];

const priorities = [
  {
    level: 'Prioritas 1',
    title: 'CRUD + validasi formulir',
    reason: 'Data yang bersih adalah dasar perhitungan yang dapat dipercaya.',
  },
  {
    level: 'Prioritas 2',
    title: 'Penilaian + skor SAW',
    reason: 'Inti penentuan urutan calon dan bahan musyawarah.',
  },
  {
    level: 'Pendukung',
    title: 'Login, responsif, Firebase',
    reason: 'Keamanan akses, kenyamanan perangkat, dan rencana penyimpanan.',
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
          Lima kebutuhan, tiga tingkat prioritas
        </div>

        <div style={{ display: 'flex', gap: 52, marginTop: 26 }}>
          <div style={{ width: 800, display: 'flex', flexDirection: 'column', gap: 12 }}>
            {needs.map((item, i) => {
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
                      width: 72,
                      flexShrink: 0,
                      fontSize: 15,
                      fontWeight: 800,
                      color: colors.maroon,
                      letterSpacing: 0.8,
                      paddingTop: 4,
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
