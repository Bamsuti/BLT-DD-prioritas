import React from 'react';
import { spring, useCurrentFrame, useVideoConfig } from 'remotion';
import { SceneChrome } from '../components/SceneChrome';
import { colors, type SceneTiming } from '../theme';

type Props = { scene: SceneTiming; index: number; total: number };

const answers = [
  {
    question: 'Masalah apa yang diselesaikan?',
    answer: 'Pendataan dan penilaian calon yang tersebar, manual, dan sulit ditelusuri.',
  },
  {
    question: 'Siapa pengguna utamanya?',
    answer: 'Petugas pengelola data BLT-DD di tingkat desa.',
  },
  {
    question: 'Mengapa fitur ini diprioritaskan?',
    answer: 'CRUD dan validasi menjaga kualitas data; skor SAW adalah inti penentuan urutan.',
  },
  {
    question: 'Bagaimana data akan disimpan?',
    answer: 'Firebase Authentication dan Cloud Firestore dengan akses berbasis role.',
  },
];

export const ClosingScene: React.FC<Props> = ({ scene, index, total }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const head = spring({ frame, fps, config: { damping: 200 } });
  const repo = spring({
    frame: Math.max(0, frame - 26),
    fps,
    config: { damping: 200 },
  });

  return (
    <SceneChrome scene={scene} index={index} total={total}>
      <div style={{ position: 'absolute', top: 140, left: 108, right: 108 }}>
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
          Penutup · empat pertanyaan kunci
        </div>
        <div
          style={{
            marginTop: 10,
            fontSize: 46,
            fontWeight: 800,
            letterSpacing: -0.7,
            opacity: head,
            transform: `translateY(${(1 - head) * 20}px)`,
          }}
        >
          Ringkasan jawaban
        </div>

        <div
          style={{
            marginTop: 22,
            display: 'grid',
            gridTemplateColumns: '1fr 1fr',
            gap: 18,
          }}
        >
          {answers.map((item, i) => {
            const enter = spring({
              frame: Math.max(0, frame - 8 - i * 7),
              fps,
              config: { damping: 200 },
            });
            return (
              <div
                key={item.question}
                style={{
                  minHeight: 172,
                  padding: '20px 24px',
                  borderRadius: 18,
                  background: i === 0 ? 'rgba(243, 226, 229, 0.92)' : 'rgba(255, 251, 248, 0.9)',
                  border: `1px solid ${i === 0 ? '#DDBFC5' : colors.line}`,
                  opacity: enter,
                  transform: `translateY(${(1 - enter) * 24}px)`,
                }}
              >
                <div
                  style={{
                    fontSize: 15,
                    fontWeight: 800,
                    letterSpacing: 1.2,
                    color: colors.maroon,
                  }}
                >
                  {String(i + 1).padStart(2, '0')} · {item.question}
                </div>
                <div style={{ marginTop: 8, fontSize: 23, fontWeight: 650, lineHeight: 1.4 }}>
                  {item.answer}
                </div>
              </div>
            );
          })}
        </div>

        <div
          style={{
            marginTop: 20,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            gap: 24,
            opacity: repo,
            transform: `translateY(${(1 - repo) * 18}px)`,
          }}
        >
          <div
            style={{
              padding: '14px 24px',
              borderRadius: 13,
              background: colors.ink,
              color: '#FFF9F5',
              fontSize: 19,
              fontWeight: 700,
            }}
          >
            github.com/Bamsuti/BLT-DD-prioritas
          </div>
          <div style={{ fontSize: 17, color: colors.muted, textAlign: 'right', lineHeight: 1.5 }}>
            Skor hanya bahan simulasi, bukan keputusan resmi.
            <br />
            Nabhan Miqdad Mubarok · 23.01.55.0017 · Kelas A1
          </div>
        </div>

        <div
          style={{
            marginTop: 14,
            fontSize: 26,
            fontWeight: 800,
            color: colors.maroon,
            opacity: repo,
          }}
        >
          Terima kasih.
        </div>
        <div style={{ marginTop: 4, fontSize: 15, color: colors.muted, opacity: repo }}>
          Kendala: waktu, project Firebase belum ada, APK belum diuji di perangkat.
          Pelajaran: kualitas data dulu, uji otomatis, dan status jujur.
        </div>
      </div>
    </SceneChrome>
  );
};
