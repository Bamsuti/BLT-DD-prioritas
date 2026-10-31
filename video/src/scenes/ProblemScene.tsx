import React from 'react';
import { spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { SceneChrome } from '../components/SceneChrome';
import { colors, type SceneTiming } from '../theme';

type Props = { scene: SceneTiming; index: number; total: number };

const problems = [
  {
    number: '01',
    title: 'Data tersebar',
    body: 'Berkas spreadsheet terpisah membuat pembaruan dan penelusuran data calon tidak konsisten.',
  },
  {
    number: '02',
    title: 'Perhitungan berulang',
    body: 'Skor prioritas dihitung manual dengan cara yang bisa berbeda antar petugas.',
  },
  {
    number: '03',
    title: 'Riwayat sulit ditelusuri',
    body: 'Perubahan nilai tidak tercatat rapi, sehingga hasil sulit dipertanggungjawabkan.',
  },
];

export const ProblemScene: React.FC<Props> = ({ scene, index, total }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  return (
    <SceneChrome scene={scene} index={index} total={total}>
      <div
        style={{
          position: 'absolute',
          top: 236,
          left: 108,
          right: 108,
          display: 'flex',
          gap: 90,
        }}
      >
        <div style={{ width: 560, paddingTop: 22 }}>
          <div
            style={{
              fontSize: 20,
              fontWeight: 800,
              letterSpacing: 5,
              color: colors.maroon,
              textTransform: 'uppercase',
            }}
          >
            Masalah
          </div>
          <div
            style={{
              marginTop: 18,
              fontSize: 60,
              lineHeight: 1.12,
              fontWeight: 800,
              letterSpacing: -1,
            }}
          >
            Pendataan masih terpisah dan manual
          </div>
          <div
            style={{
              marginTop: 24,
              fontSize: 25,
              lineHeight: 1.55,
              color: colors.muted,
              maxWidth: 520,
            }}
          >
            Tujuh kriteria sudah ditetapkan, tetapi proses pencatatan dan
            perhitungannya belum berjalan dalam satu alur yang konsisten.
          </div>
        </div>

        <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 20 }}>
          {problems.map((item, i) => {
            const enter = spring({
              frame: Math.max(0, frame - 10 - i * 9),
              fps,
              config: { damping: 200 },
            });
            return (
              <div
                key={item.number}
                style={{
                  display: 'flex',
                  gap: 26,
                  padding: '22px 30px',
                  borderRadius: 18,
                  background: 'rgba(255, 251, 248, 0.88)',
                  border: `1px solid ${colors.line}`,
                  boxShadow: '0 16px 34px rgba(64, 32, 40, 0.07)',
                  opacity: enter,
                  transform: `translateX(${(1 - enter) * 46}px)`,
                }}
              >
                <div
                  style={{
                    width: 62,
                    height: 62,
                    flexShrink: 0,
                    borderRadius: 14,
                    background: colors.maroonSoft,
                    color: colors.maroon,
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    fontSize: 22,
                    fontWeight: 800,
                    letterSpacing: 1,
                  }}
                >
                  {item.number}
                </div>
                <div>
                  <div style={{ fontSize: 29, fontWeight: 750 }}>{item.title}</div>
                  <div
                    style={{
                      marginTop: 7,
                      fontSize: 21,
                      lineHeight: 1.5,
                      color: colors.muted,
                    }}
                  >
                    {item.body}
                  </div>
                </div>
              </div>
            );
          })}

          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: 22,
              padding: '18px 28px',
              borderRadius: 18,
              background: colors.ink,
              color: '#FFF9F5',
            }}
          >
            <div
              style={{
                fontSize: 13,
                fontWeight: 800,
                letterSpacing: 1.8,
                color: '#E8B9A8',
                width: 150,
                flexShrink: 0,
              }}
            >
              PENGGUNA UTAMA
            </div>
            <div>
              <div style={{ fontSize: 24, fontWeight: 800 }}>
                Petugas pengelola data BLT-DD di tingkat desa
              </div>
              <div style={{ marginTop: 4, fontSize: 17, color: '#D9C9C3' }}>
                Mendata calon · memperbarui nilai · menyiapkan bahan musyawarah
              </div>
            </div>
          </div>
        </div>
      </div>
    </SceneChrome>
  );
};
