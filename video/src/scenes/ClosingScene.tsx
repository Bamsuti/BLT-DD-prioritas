import React from 'react';
import { spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { SceneChrome } from '../components/SceneChrome';
import { colors, type SceneTiming } from '../theme';

type Props = { scene: SceneTiming; index: number; total: number };

const notes = [
  {
    title: 'Bahan simulasi',
    body: 'Skor SAW hanya untuk peninjauan awal, bukan keputusan resmi penerima bantuan.',
  },
  {
    title: 'Data sintetis',
    body: 'Seluruh data demonstrasi dibuat untuk prototipe dan bukan data warga nyata.',
  },
  {
    title: 'Sumber terbuka',
    body: 'Kode, dokumentasi, dan hasil pengujian tersedia di repositori GitHub.',
  },
];

export const ClosingScene: React.FC<Props> = ({ scene, index, total }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const head = spring({ frame, fps, config: { damping: 200 } });
  const repo = spring({
    frame: Math.max(0, frame - 20),
    fps,
    config: { damping: 200 },
  });
  const thanks = spring({
    frame: Math.max(0, frame - 34),
    fps,
    config: { damping: 200 },
  });

  return (
    <SceneChrome scene={scene} index={index} total={total}>
      <div style={{ position: 'absolute', top: 186, left: 108, right: 108 }}>
        <div
          style={{
            fontSize: 20,
            fontWeight: 800,
            letterSpacing: 5,
            color: colors.maroon,
            textTransform: 'uppercase',
            opacity: head,
          }}
        >
          Penutup
        </div>
        <div
          style={{
            marginTop: 14,
            fontSize: 62,
            fontWeight: 800,
            letterSpacing: -1.2,
            lineHeight: 1.14,
            opacity: head,
            transform: `translateY(${(1 - head) * 30}px)`,
          }}
        >
          Bahan simulasi,
          <br />
          bukan keputusan resmi
        </div>

        <div style={{ display: 'flex', gap: 22, marginTop: 40 }}>
          {notes.map((note, i) => {
            const enter = spring({
              frame: Math.max(0, frame - 10 - i * 8),
              fps,
              config: { damping: 200 },
            });
            return (
              <div
                key={note.title}
                style={{
                  flex: 1,
                  padding: '26px 28px',
                  borderRadius: 18,
                  background: 'rgba(255, 251, 248, 0.88)',
                  border: `1px solid ${colors.line}`,
                  opacity: enter,
                  transform: `translateY(${(1 - enter) * 26}px)`,
                }}
              >
                <div
                  style={{
                    width: 34,
                    height: 34,
                    borderRadius: '50%',
                    background: colors.maroonSoft,
                    color: colors.maroon,
                    fontWeight: 800,
                    fontSize: 17,
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    marginBottom: 16,
                  }}
                >
                  {String(i + 1).padStart(2, '0')}
                </div>
                <div style={{ fontSize: 24, fontWeight: 800 }}>{note.title}</div>
                <div
                  style={{
                    marginTop: 8,
                    fontSize: 19,
                    lineHeight: 1.5,
                    color: colors.muted,
                  }}
                >
                  {note.body}
                </div>
              </div>
            );
          })}
        </div>

        <div
          style={{
            marginTop: 34,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            gap: 24,
            opacity: repo,
            transform: `translateY(${(1 - repo) * 20}px)`,
          }}
        >
          <div
            style={{
              padding: '16px 26px',
              borderRadius: 14,
              background: colors.ink,
              color: '#FFF9F5',
              fontSize: 21,
              fontWeight: 700,
              letterSpacing: 0.2,
            }}
          >
            github.com/Bamsuti/BLT-DD-prioritas
          </div>
          <div
            style={{
              fontSize: 20,
              color: colors.muted,
              textAlign: 'right',
              lineHeight: 1.5,
            }}
          >
            Nabhan Miqdad Mubarok · 23.01.55.0017
            <br />
            Mobile and Web Application Development · 2026/2027
          </div>
        </div>

        <div
          style={{
            marginTop: 26,
            fontSize: 23,
            fontWeight: 700,
            color: colors.maroon,
            opacity: thanks,
          }}
        >
          Terima kasih.
        </div>
      </div>
    </SceneChrome>
  );
};
