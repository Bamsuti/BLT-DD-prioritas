import React from 'react';
import {
  OffthreadVideo,
  spring,
  staticFile,
  useCurrentFrame,
  useVideoConfig,
} from 'remotion';
import { SceneChrome } from '../components/SceneChrome';
import { colors, type SceneTiming } from '../theme';

type Props = { scene: SceneTiming; index: number; total: number };

const steps = [
  { label: 'Login', at: 0 },
  { label: 'Beranda', at: 8 },
  { label: 'Data calon', at: 15 },
  { label: 'Validasi form', at: 20 },
  { label: 'Penilaian', at: 30 },
  { label: 'Hasil', at: 35 },
];

export const DemoScene: React.FC<Props> = ({ scene, index, total }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const seconds = frame / fps;
  const activeIndex = steps.reduce(
    (current, step, i) => (seconds >= step.at ? i : current),
    0,
  );
  const enter = spring({ frame, fps, config: { damping: 200 } });

  return (
    <SceneChrome scene={scene} index={index} total={total}>
      <div style={{ position: 'absolute', top: 112, left: 108, right: 108 }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
          <div style={{ fontSize: 38, fontWeight: 800, letterSpacing: -0.5 }}>
            Demo prototipe berjalan
          </div>
          <div
            style={{
              padding: '8px 16px',
              borderRadius: 999,
              background: colors.ink,
              color: '#FFF9F5',
              fontSize: 14,
              fontWeight: 750,
              letterSpacing: 1.6,
            }}
          >
            REKAMAN RUNTIME · WEB
          </div>
        </div>

        <div style={{ display: 'flex', gap: 8, marginTop: 14 }}>
          {steps.map((step, i) => {
            const active = i === activeIndex;
            return (
              <div
                key={step.label}
                style={{
                  flex: 1,
                  padding: '8px 10px',
                  borderRadius: 9,
                  textAlign: 'center',
                  fontSize: 14,
                  fontWeight: 750,
                  background: active ? colors.maroon : 'rgba(255, 251, 248, 0.82)',
                  color: active ? '#FFF7F3' : colors.muted,
                  border: `1px solid ${active ? colors.maroon : colors.line}`,
                }}
              >
                {step.label}
              </div>
            );
          })}
        </div>

        <div
          style={{
            marginTop: 16,
            width: 1040,
            marginLeft: 'auto',
            marginRight: 'auto',
            borderRadius: 16,
            overflow: 'hidden',
            border: `1px solid ${colors.line}`,
            background: '#FFFFFF',
            boxShadow: '0 30px 70px rgba(64, 32, 40, 0.24)',
            opacity: enter,
            transform: `translateY(${(1 - enter) * 26}px)`,
          }}
        >
          <div
            style={{
              height: 40,
              display: 'flex',
              alignItems: 'center',
              gap: 9,
              padding: '0 16px',
              background: '#FBF7F4',
              borderBottom: `1px solid ${colors.line}`,
            }}
          >
            <span style={{ width: 10, height: 10, borderRadius: '50%', background: '#D9B8B2' }} />
            <span style={{ width: 10, height: 10, borderRadius: '50%', background: '#E5CFC0' }} />
            <span style={{ width: 10, height: 10, borderRadius: '50%', background: '#D8CBC4' }} />
            <span
              style={{
                marginLeft: 12,
                padding: '3px 12px',
                borderRadius: 6,
                background: '#FFFFFF',
                border: `1px solid ${colors.line}`,
                fontSize: 13,
                color: colors.muted,
              }}
            >
              bamsuti.github.io/BLT-DD-prioritas
            </span>
          </div>
          <OffthreadVideo
            src={staticFile('demo/desktop.mp4')}
            muted
            style={{ width: 1040, display: 'block' }}
          />
        </div>
      </div>
    </SceneChrome>
  );
};
