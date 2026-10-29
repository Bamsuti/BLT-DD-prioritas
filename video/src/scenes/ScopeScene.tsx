import React from 'react';
import { spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { SceneChrome } from '../components/SceneChrome';
import { colors, type SceneTiming } from '../theme';

type Props = { scene: SceneTiming; index: number; total: number };

const included = [
  'CRUD data calon dan validasi formulir',
  'Tujuh kriteria dengan skala 1–5',
  'Skor SAW dan pengurutan otomatis',
  'Tampilan responsif Web dan Android',
  'Kode Firebase Auth + Firestore disiapkan',
];

const excluded = [
  'Pencairan dana bantuan',
  'Integrasi sistem pemerintah',
  'Penggunaan data warga nyata',
  'Keputusan resmi penerima bantuan',
];

const ListCard: React.FC<{
  title: string;
  subtitle: string;
  items: string[];
  tone: 'in' | 'out';
  enter: number;
}> = ({ title, subtitle, items, tone, enter }) => {
  const accent = tone === 'in' ? colors.maroon : colors.muted;
  return (
    <div
      style={{
        flex: 1,
        padding: '30px 34px',
        borderRadius: 20,
        background:
          tone === 'in' ? 'rgba(255, 251, 248, 0.92)' : 'rgba(247, 242, 239, 0.72)',
        border: `1px solid ${tone === 'in' ? colors.line : '#D8C8C2'}`,
        opacity: enter,
        transform: `translateY(${(1 - enter) * 34}px)`,
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
        <span
          style={{
            width: 10,
            height: 10,
            borderRadius: '50%',
            background: accent,
            display: 'inline-block',
          }}
        />
        <span style={{ fontSize: 27, fontWeight: 800, color: accent }}>{title}</span>
      </div>
      <div style={{ marginTop: 8, fontSize: 18, color: colors.muted }}>{subtitle}</div>
      <div style={{ marginTop: 22, display: 'flex', flexDirection: 'column', gap: 14 }}>
        {items.map((item) => (
          <div
            key={item}
            style={{ display: 'flex', gap: 12, alignItems: 'flex-start' }}
          >
            <span
              style={{
                marginTop: 9,
                width: 8,
                height: 8,
                borderRadius: 2,
                background: accent,
                opacity: tone === 'in' ? 1 : 0.45,
                flexShrink: 0,
              }}
            />
            <span
              style={{
                fontSize: 22,
                lineHeight: 1.45,
                color: tone === 'in' ? colors.ink : colors.muted,
              }}
            >
              {item}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
};

export const ScopeScene: React.FC<Props> = ({ scene, index, total }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const left = spring({ frame: Math.max(0, frame - 6), fps, config: { damping: 200 } });
  const right = spring({ frame: Math.max(0, frame - 14), fps, config: { damping: 200 } });
  const note = spring({ frame: Math.max(0, frame - 28), fps, config: { damping: 200 } });

  return (
    <SceneChrome scene={scene} index={index} total={total}>
      <div style={{ position: 'absolute', top: 178, left: 108, right: 108 }}>
        <div
          style={{
            fontSize: 20,
            fontWeight: 800,
            letterSpacing: 5,
            color: colors.maroon,
            textTransform: 'uppercase',
          }}
        >
          Ruang lingkup
        </div>
        <div
          style={{
            marginTop: 14,
            fontSize: 54,
            fontWeight: 800,
            letterSpacing: -0.8,
          }}
        >
          Apa yang termasuk dan tidak termasuk
        </div>

        <div style={{ display: 'flex', gap: 28, marginTop: 26 }}>
          <ListCard
            title="Termasuk dalam prototipe"
            subtitle="Fitur yang berjalan pada mode demo"
            items={included}
            tone="in"
            enter={left}
          />
          <ListCard
            title="Di luar ruang lingkup"
            subtitle="Tidak ditangani aplikasi ini"
            items={excluded}
            tone="out"
            enter={right}
          />
        </div>

        <div
          style={{
            marginTop: 20,
            padding: '18px 26px',
            borderRadius: 14,
            background: colors.warningBg,
            border: '1px solid #E9D3AC',
            color: colors.warning,
            fontSize: 20,
            fontWeight: 650,
            display: 'flex',
            alignItems: 'center',
            gap: 14,
            opacity: note,
            transform: `translateY(${(1 - note) * 18}px)`,
          }}
        >
          <span style={{ fontSize: 22 }}>⚠</span>
          Firebase Authentication dan Cloud Firestore sudah disiapkan, tetapi
          belum terhubung ke proyek nyata — aplikasi berjalan dalam mode demo.
        </div>
      </div>
    </SceneChrome>
  );
};
