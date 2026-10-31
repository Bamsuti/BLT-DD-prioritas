import React from 'react';
import { OffthreadVideo, spring, staticFile, useCurrentFrame, useVideoConfig } from 'remotion';
import { SceneChrome } from '../components/SceneChrome';
import { ScreenshotFrame } from '../components/ScreenshotFrame';
import { colors, type SceneTiming } from '../theme';

type Props = { scene: SceneTiming; index: number; total: number };

const facts = [
  {
    title: 'Layar sempit',
    body: 'NavigationBar di bawah, kartu bertumpuk, dialog formulir dapat digulir.',
  },
  {
    title: 'Layar lebar',
    body: 'NavigationRail di samping, ringkasan dan daftar memakai ruang horizontal.',
  },
];

export const ResponsiveScene: React.FC<Props> = ({ scene, index, total }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const phone = spring({ frame: Math.max(0, frame - 6), fps, config: { damping: 200 } });
  const shot = spring({ frame: Math.max(0, frame - 20), fps, config: { damping: 200 } });

  return (
    <SceneChrome scene={scene} index={index} total={total}>
      <div style={{ position: 'absolute', top: 148, left: 108, right: 108 }}>
        <div
          style={{
            fontSize: 20,
            fontWeight: 800,
            letterSpacing: 5,
            color: colors.maroon,
            textTransform: 'uppercase',
          }}
        >
          Tampilan responsif
        </div>
        <div style={{ marginTop: 12, fontSize: 46, fontWeight: 800, letterSpacing: -0.7 }}>
          Satu aplikasi, dua ukuran layar
        </div>
      </div>

      <div
        style={{
          position: 'absolute',
          top: 258,
          left: 210,
          width: 302,
          padding: 12,
          borderRadius: 38,
          background: '#241B1F',
          boxShadow: '0 30px 70px rgba(64, 32, 40, 0.28)',
          opacity: phone,
          transform: `translateY(${(1 - phone) * 40}px)`,
        }}
      >
        <div style={{ borderRadius: 27, overflow: 'hidden', background: '#FFFFFF' }}>
          <OffthreadVideo
            src={staticFile('demo/mobile.mp4')}
            muted
            style={{ width: 278, display: 'block' }}
          />
        </div>
      </div>
      <div
        style={{
          position: 'absolute',
          top: 890,
          left: 210,
          width: 302,
          textAlign: 'center',
          fontSize: 16,
          fontWeight: 750,
          color: colors.muted,
          opacity: phone,
        }}
      >
        390 × 844 · NavigationBar
      </div>

      <div style={{ position: 'absolute', top: 250, left: 650, right: 108 }}>
        <div style={{ display: 'flex', gap: 18 }}>
          {facts.map((fact, i) => {
            const enter = spring({
              frame: Math.max(0, frame - 12 - i * 8),
              fps,
              config: { damping: 200 },
            });
            return (
              <div
                key={fact.title}
                style={{
                  flex: 1,
                  padding: '20px 22px',
                  borderRadius: 16,
                  background: 'rgba(255, 251, 248, 0.9)',
                  border: `1px solid ${colors.line}`,
                  opacity: enter,
                  transform: `translateY(${(1 - enter) * 24}px)`,
                }}
              >
                <div style={{ fontSize: 22, fontWeight: 800 }}>{fact.title}</div>
                <div style={{ marginTop: 6, fontSize: 17, lineHeight: 1.45, color: colors.muted }}>
                  {fact.body}
                </div>
              </div>
            );
          })}
        </div>

        <div
          style={{
            marginTop: 20,
            opacity: shot,
            transform: `translateY(${(1 - shot) * 30}px)`,
          }}
        >
          <ScreenshotFrame
            src="screenshots/hasil.png"
            label="Hasil prioritas — 1280×800 · NavigationRail"
            width={620}
          />
        </div>
      </div>
    </SceneChrome>
  );
};
