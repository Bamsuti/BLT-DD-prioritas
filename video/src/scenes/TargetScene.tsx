import React from 'react';
import { spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { SceneChrome } from '../components/SceneChrome';
import { ScreenshotFrame } from '../components/ScreenshotFrame';
import { colors, type SceneTiming } from '../theme';

type Props = { scene: SceneTiming; index: number; total: number };

const points = [
  'Satu alur kerja: data calon, nilai, lalu prioritas.',
  'Lima halaman dengan istilah dan struktur yang konsisten.',
  'Web dan Android dari satu basis kode Flutter.',
];

export const TargetScene: React.FC<Props> = ({ scene, index, total }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const shotA = spring({
    frame: Math.max(0, frame - 8),
    fps,
    config: { damping: 200 },
  });
  const shotB = spring({
    frame: Math.max(0, frame - 22),
    fps,
    config: { damping: 200 },
  });

  return (
    <SceneChrome scene={scene} index={index} total={total}>
      <div
        style={{
          position: 'absolute',
          top: 188,
          left: 108,
          right: 108,
          display: 'flex',
          gap: 70,
          alignItems: 'center',
        }}
      >
        <div style={{ width: 620 }}>
          <div
            style={{
              fontSize: 20,
              fontWeight: 800,
              letterSpacing: 5,
              color: colors.maroon,
              textTransform: 'uppercase',
            }}
          >
            Target pengguna
          </div>
          <div
            style={{
              marginTop: 18,
              fontSize: 56,
              lineHeight: 1.12,
              fontWeight: 800,
              letterSpacing: -0.8,
            }}
          >
            Petugas pengelola data BLT-DD
          </div>
          <div
            style={{
              marginTop: 22,
              fontSize: 24,
              lineHeight: 1.55,
              color: colors.muted,
            }}
          >
            Aplikasi menyatukan pendataan, penilaian tujuh kriteria, dan
            peninjauan prioritas dalam satu tempat.
          </div>

          <div style={{ marginTop: 30, display: 'flex', flexDirection: 'column', gap: 16 }}>
            {points.map((point, i) => {
              const enter = spring({
                frame: Math.max(0, frame - 16 - i * 7),
                fps,
                config: { damping: 200 },
              });
              return (
                <div
                  key={point}
                  style={{
                    display: 'flex',
                    gap: 14,
                    alignItems: 'flex-start',
                    opacity: enter,
                    transform: `translateY(${(1 - enter) * 20}px)`,
                  }}
                >
                  <div
                    style={{
                      width: 30,
                      height: 30,
                      borderRadius: '50%',
                      background: colors.maroonSoft,
                      color: colors.maroon,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      fontSize: 17,
                      fontWeight: 800,
                      flexShrink: 0,
                      marginTop: 2,
                    }}
                  >
                    ✓
                  </div>
                  <span style={{ fontSize: 22, lineHeight: 1.5 }}>{point}</span>
                </div>
              );
            })}
          </div>
        </div>

        <div style={{ flex: 1, position: 'relative', height: 640 }}>
          <div
            style={{
              position: 'absolute',
              top: 6,
              left: 0,
              opacity: shotA,
              transform: `translateX(${(1 - shotA) * 70}px)`,
            }}
          >
            <ScreenshotFrame
              src="screenshots/beranda.png"
              label="Beranda — ringkasan data"
              width={690}
              rotate={-1.2}
            />
          </div>
          <div
            style={{
              position: 'absolute',
              right: 0,
              bottom: -24,
              opacity: shotB,
              transform: `translateX(${(1 - shotB) * 90}px)`,
            }}
          >
            <ScreenshotFrame
              src="screenshots/data-calon.png"
              label="Data Calon Penerima — CRUD"
              width={540}
              rotate={1.8}
              style={{ border: '6px solid #FFFFFF' }}
            />
          </div>
        </div>
      </div>
    </SceneChrome>
  );
};
