import React from 'react';
import { interpolate, spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { SceneChrome } from '../components/SceneChrome';
import { colors, fontFamily, type SceneTiming } from '../theme';

type Props = { scene: SceneTiming; index: number; total: number };

const rows = [
  { name: 'Calon Simulasi A', code: 'SIM-001', score: '85,0', width: '100%' },
  { name: 'Calon Simulasi E', code: 'SIM-005', score: '81,0', width: '94%' },
  { name: 'Calon Simulasi C', code: 'SIM-003', score: '78,0', width: '90%' },
];

export const IntroScene: React.FC<Props> = ({ scene, index, total }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const title = spring({ frame, fps, config: { damping: 200 } });
  const card = spring({
    frame: Math.max(0, frame - 12),
    fps,
    config: { damping: 200 },
  });

  return (
    <SceneChrome scene={scene} index={index} total={total}>
      <div
        style={{
          position: 'absolute',
          top: 208,
          left: 108,
          right: 108,
          display: 'flex',
          alignItems: 'center',
          gap: 88,
        }}
      >
        <div style={{ flex: 1.08 }}>
          <div
            style={{
              fontSize: 21,
              fontWeight: 800,
              letterSpacing: 5,
              color: colors.maroon,
              textTransform: 'uppercase',
              opacity: title,
            }}
          >
            Prototipe Akademik · Flutter & Firebase
          </div>
          <div
            style={{
              marginTop: 20,
              fontSize: 104,
              lineHeight: 1.02,
              fontWeight: 800,
              letterSpacing: -2.4,
              transform: `translateY(${(1 - title) * 42}px)`,
              opacity: title,
            }}
          >
            BLT-DD
            <br />
            Prioritas
          </div>
          <div
            style={{
              marginTop: 26,
              fontSize: 30,
              lineHeight: 1.45,
              color: colors.muted,
              maxWidth: 720,
              opacity: title,
            }}
          >
            Penentuan prioritas calon penerima bantuan langsung tunai dana desa
            berbasis cross-platform.
          </div>

          <div style={{ display: 'flex', gap: 12, marginTop: 34, flexWrap: 'wrap' }}>
            {['Nabhan Miqdad Mubarok', '23.01.55.0017', 'Kelas A1'].map((item) => (
              <div
                key={item}
                style={{
                  padding: '11px 22px',
                  borderRadius: 999,
                  border: `1px solid ${colors.line}`,
                  background: 'rgba(255, 251, 248, 0.80)',
                  fontSize: 19,
                  fontWeight: 650,
                }}
              >
                {item}
              </div>
            ))}
          </div>

          <div style={{ marginTop: 20, fontSize: 18, color: colors.muted, letterSpacing: 0.2 }}>
            Mobile and Web Application Development · Ganjil 2026/2027
          </div>
        </div>

        <div
          style={{
            width: 548,
            opacity: card,
            transform: `translateY(${(1 - card) * 46}px)`,
          }}
        >
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              marginBottom: 16,
              paddingLeft: 6,
            }}
          >
            <span style={{ fontSize: 18, fontWeight: 750, color: colors.muted }}>
              HASIL PRIORITAS
            </span>
            <span
              style={{
                padding: '7px 14px',
                borderRadius: 999,
                background: colors.maroonSoft,
                color: colors.maroon,
                fontSize: 13,
                fontWeight: 800,
                letterSpacing: 1.4,
              }}
            >
              MODE DEMO
            </span>
          </div>

          <div
            style={{
              background: colors.cream,
              border: `1px solid ${colors.line}`,
              borderRadius: 22,
              padding: '28px 30px 24px',
              boxShadow: '0 26px 60px rgba(64, 32, 40, 0.16)',
            }}
          >
            {rows.map((row, i) => {
              const grow = spring({
                frame: Math.max(0, frame - 22 - i * 8),
                fps,
                config: { damping: 200 },
              });
              return (
                <div key={row.code} style={{ marginBottom: i === rows.length - 1 ? 0 : 26 }}>
                  <div
                    style={{
                      display: 'flex',
                      alignItems: 'baseline',
                      justifyContent: 'space-between',
                      marginBottom: 9,
                    }}
                  >
                    <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
                      <span style={{ fontSize: 22, fontWeight: 750 }}>{row.name}</span>
                      <span style={{ fontSize: 14, color: colors.muted }}>{row.code}</span>
                    </div>
                    <span style={{ fontSize: 24, fontWeight: 800, color: colors.maroon }}>
                      {row.score}
                    </span>
                  </div>
                  <div
                    style={{
                      height: 12,
                      borderRadius: 999,
                      background: colors.maroonSoft,
                      overflow: 'hidden',
                    }}
                  >
                    <div
                      style={{
                        height: '100%',
                        width: row.width,
                        borderRadius: 999,
                        background: `linear-gradient(90deg, ${colors.maroonDark}, ${colors.maroon})`,
                        transform: `scaleX(${grow})`,
                        transformOrigin: 'left',
                      }}
                    />
                  </div>
                </div>
              );
            })}
            <div
              style={{
                marginTop: 26,
                paddingTop: 18,
                borderTop: `1px solid ${colors.line}`,
                fontSize: 14,
                color: colors.muted,
                display: 'flex',
                justifyContent: 'space-between',
              }}
            >
              <span>Data sintetis · skor simulasi</span>
              <span style={{ fontWeight: 700 }}>5 halaman · 7 kriteria</span>
            </div>
          </div>
        </div>
      </div>
    </SceneChrome>
  );
};
