import React from 'react';
import { spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { SceneChrome } from '../components/SceneChrome';
import { colors, type SceneTiming } from '../theme';

type Props = { scene: SceneTiming; index: number; total: number };

const layers = [
  {
    tag: 'UI',
    title: 'Flutter — lima halaman',
    body: 'Login · Beranda · Data Calon · Penilaian · Hasil',
  },
  {
    tag: 'MODEL',
    title: 'Tujuh kriteria & skor SAW',
    body: 'normalisasi nilai ÷ 5 · bobot demo · ranking menurun',
  },
  {
    tag: 'BACKEND',
    title: 'AppBackend',
    body: 'mode demo di memori · Firebase Auth + Firestore saat aktif',
  },
  {
    tag: 'FIREBASE',
    title: 'Authentication & Cloud Firestore',
    body: 'sesi petugas · dokumen data · security rules berbasis role',
  },
];

const fields = [
  ['idSimulasi', 'string — kode unik, mis. SIM-001'],
  ['namaLabel', 'string — label fiktif'],
  ['dusun', 'string — kelompok simulasi'],
  ['catatan', 'string — opsional'],
  ['scores.C1 … C7', 'integer 1–5 — tujuh kriteria'],
  ['createdAt / updatedAt', 'timestamp — jejak waktu'],
];

export const TechScene: React.FC<Props> = ({ scene, index, total }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  return (
    <SceneChrome scene={scene} index={index} total={total}>
      <div style={{ position: 'absolute', top: 145, left: 108, right: 108 }}>
        <div
          style={{
            fontSize: 20,
            fontWeight: 800,
            letterSpacing: 5,
            color: colors.maroon,
            textTransform: 'uppercase',
          }}
        >
          Rencana teknis & penyimpanan data
        </div>
        <div style={{ marginTop: 12, fontSize: 46, fontWeight: 800, letterSpacing: -0.7 }}>
          Arsitektur dan rancangan Firestore
        </div>

        <div style={{ display: 'flex', gap: 54, marginTop: 24 }}>
          <div style={{ width: 760 }}>
            {layers.map((layer, i) => {
              const enter = spring({
                frame: Math.max(0, frame - 8 - i * 6),
                fps,
                config: { damping: 200 },
              });
              return (
                <React.Fragment key={layer.tag}>
                  <div
                    style={{
                      padding: '17px 24px',
                      borderRadius: 16,
                      background:
                        i === 3 ? 'rgba(243, 226, 229, 0.92)' : 'rgba(255, 251, 248, 0.88)',
                      border: `1px solid ${i === 3 ? '#DDBFC5' : colors.line}`,
                      opacity: enter,
                      transform: `translateX(${(1 - enter) * -24}px)`,
                    }}
                  >
                    <div style={{ display: 'flex', alignItems: 'baseline', gap: 14 }}>
                      <span
                        style={{
                          fontSize: 13,
                          fontWeight: 800,
                          letterSpacing: 1.6,
                          color: colors.maroon,
                          width: 88,
                          flexShrink: 0,
                        }}
                      >
                        {layer.tag}
                      </span>
                      <div>
                        <div style={{ fontSize: 24, fontWeight: 800 }}>{layer.title}</div>
                        <div style={{ marginTop: 4, fontSize: 17, color: colors.muted }}>
                          {layer.body}
                        </div>
                      </div>
                    </div>
                  </div>
                  {i < layers.length - 1 && (
                    <div
                      style={{
                        height: 22,
                        display: 'flex',
                        alignItems: 'center',
                        paddingLeft: 52,
                        color: colors.maroon,
                        fontSize: 18,
                      }}
                    >
                      ↓
                    </div>
                  )}
                </React.Fragment>
              );
            })}
            <div
              style={{
                marginTop: 16,
                padding: '12px 18px',
                borderRadius: 12,
                background: colors.warningBg,
                border: '1px solid #E9D3AC',
                color: colors.warning,
                fontSize: 16,
                fontWeight: 650,
                lineHeight: 1.45,
              }}
            >
              Firebase belum dihubungkan ke proyek nyata; demo berjalan di mode memori.
              Snapshot hasil dan audit trail direncanakan pada fase berikutnya.
            </div>
          </div>

          <div style={{ flex: 1 }}>
            <div
              style={{
                padding: '22px 24px',
                borderRadius: 18,
                background: '#FFFFFF',
                border: `1px solid ${colors.line}`,
                boxShadow: '0 18px 40px rgba(64, 32, 40, 0.10)',
              }}
            >
              <div
                style={{
                  fontFamily: 'Consolas, "Courier New", monospace',
                  fontSize: 20,
                  fontWeight: 700,
                  color: colors.maroon,
                }}
              >
                calon_penerima/{'{id}'}
              </div>
              <div style={{ marginTop: 14, display: 'flex', flexDirection: 'column', gap: 9 }}>
                {fields.map(([name, desc]) => (
                  <div key={name} style={{ display: 'flex', gap: 14, alignItems: 'baseline' }}>
                    <span
                      style={{
                        fontFamily: 'Consolas, "Courier New", monospace',
                        fontSize: 15,
                        fontWeight: 700,
                        color: colors.ink,
                        width: 210,
                        flexShrink: 0,
                      }}
                    >
                      {name}
                    </span>
                    <span style={{ fontSize: 15, color: colors.muted, lineHeight: 1.35 }}>
                      {desc}
                    </span>
                  </div>
                ))}
              </div>
            </div>

            <div
              style={{
                marginTop: 16,
                padding: '18px 22px',
                borderRadius: 16,
                background: 'rgba(255, 251, 248, 0.9)',
                border: `1px solid ${colors.line}`,
              }}
            >
              <div
                style={{
                  fontFamily: 'Consolas, "Courier New", monospace',
                  fontSize: 18,
                  fontWeight: 700,
                  color: colors.maroon,
                }}
              >
                users/{'{uid}'}
              </div>
              <div style={{ marginTop: 6, fontSize: 16, color: colors.muted, lineHeight: 1.45 }}>
                role: <strong>admin</strong> atau <strong>petugas</strong> — dibaca
                security rules; dokumen tidak dapat ditulis dari client.
              </div>
            </div>
          </div>
        </div>
      </div>
    </SceneChrome>
  );
};
