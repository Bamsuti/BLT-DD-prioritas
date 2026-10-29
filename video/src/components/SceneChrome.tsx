import React from 'react';
import { AbsoluteFill, useCurrentFrame, useVideoConfig } from 'remotion';
import { colors, fontFamily, type SceneTiming } from '../theme';

type SceneChromeProps = {
  scene: SceneTiming;
  index: number;
  total: number;
  children: React.ReactNode;
};

const Captions: React.FC<{ scene: SceneTiming }> = ({ scene }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const captionFrames = Math.round(scene.audio * fps);
  const weights = scene.captions.map((text) => text.length);
  const totalWeight = weights.reduce((sum, value) => sum + value, 0);

  let cursor = 0;
  const windows = scene.captions.map((text, i) => {
    const from = Math.round((cursor / totalWeight) * captionFrames);
    cursor += weights[i];
    const to = Math.round((cursor / totalWeight) * captionFrames);
    return { text, from, to };
  });

  const active =
    windows.find((item) => frame >= item.from && frame < item.to) ??
    windows[windows.length - 1];

  const localFrame = frame - active.from;
  const duration = Math.max(active.to - active.from, 1);
  const opacity = Math.min(
    1,
    localFrame / 8,
    Math.max(0, duration - localFrame) / 8,
  );

  return (
    <div
      style={{
        position: 'absolute',
        left: 0,
        right: 0,
        bottom: 44,
        display: 'flex',
        justifyContent: 'center',
        opacity,
      }}
    >
      <div
        style={{
          maxWidth: 1420,
          padding: '18px 34px',
          borderRadius: 18,
          background: 'rgba(36, 27, 31, 0.84)',
          color: '#FFF9F5',
          fontFamily,
          fontSize: 33,
          lineHeight: 1.4,
          fontWeight: 500,
          textAlign: 'center',
          boxShadow: '0 18px 40px rgba(46, 22, 28, 0.22)',
        }}
      >
        {active.text}
      </div>
    </div>
  );
};

export const SceneChrome: React.FC<SceneChromeProps> = ({
  scene,
  index,
  total,
  children,
}) => {
  return (
    <AbsoluteFill
      style={{
        fontFamily,
        color: colors.ink,
        background:
          'linear-gradient(135deg, #FCF8F5 0%, #F6EDE8 52%, #EFE1DB 100%)',
      }}
    >
      <div
        style={{
          position: 'absolute',
          width: 720,
          height: 720,
          borderRadius: '50%',
          right: -220,
          top: -300,
          background:
            'radial-gradient(circle at 30% 30%, rgba(122,28,46,0.10), rgba(122,28,46,0))',
        }}
      />
      <div
        style={{
          position: 'absolute',
          width: 620,
          height: 620,
          borderRadius: '50%',
          left: -240,
          bottom: -280,
          background:
            'radial-gradient(circle at 60% 40%, rgba(184,87,74,0.10), rgba(184,87,74,0))',
        }}
      />

      <div
        style={{
          position: 'absolute',
          top: 52,
          left: 72,
          right: 72,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
          <div
            style={{
              width: 46,
              height: 46,
              borderRadius: 12,
              background: colors.maroon,
              color: '#FFF7F3',
              fontWeight: 800,
              fontSize: 19,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              letterSpacing: 0.5,
            }}
          >
            BD
          </div>
          <div style={{ display: 'flex', flexDirection: 'column' }}>
            <span style={{ fontWeight: 800, fontSize: 23 }}>
              BLT-DD Prioritas
            </span>
            <span style={{ fontSize: 15, color: colors.muted, marginTop: 2 }}>
              Prototipe Akademik
            </span>
          </div>
        </div>

        <div
          style={{
            padding: '9px 18px',
            borderRadius: 999,
            border: `1px solid ${colors.line}`,
            background: 'rgba(255, 251, 248, 0.72)',
            fontSize: 16,
            fontWeight: 700,
            letterSpacing: 2.4,
            textTransform: 'uppercase',
            color: colors.maroon,
          }}
        >
          {scene.title} · {String(index + 1).padStart(2, '0')} /{' '}
          {String(total).padStart(2, '0')}
        </div>
      </div>

      {children}
      <Captions scene={scene} />
    </AbsoluteFill>
  );
};
