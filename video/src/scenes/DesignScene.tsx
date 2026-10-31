import React from 'react';
import { Img, spring, staticFile, useCurrentFrame, useVideoConfig } from 'remotion';
import { SceneChrome } from '../components/SceneChrome';
import { colors, type SceneTiming } from '../theme';

type Props = { scene: SceneTiming; index: number; total: number };

const flow = ['Login', 'Beranda', 'Data Calon', 'Penilaian', 'Hasil'];

const wireframes = [
  {
    src: 'wireframes/01-login-wireframe.svg',
    label: 'Login — autentikasi',
  },
  {
    src: 'wireframes/03-data-calon-wireframe.svg',
    label: 'Data calon — CRUD',
  },
  {
    src: 'wireframes/05-hasil-prioritas-wireframe.svg',
    label: 'Hasil — peringkat',
  },
];

export const DesignScene: React.FC<Props> = ({ scene, index, total }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const flowIn = spring({ frame: Math.max(0, frame - 8), fps, config: { damping: 200 } });
  const mapIn = spring({ frame: Math.max(0, frame - 16), fps, config: { damping: 200 } });

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
          Rancangan
        </div>
        <div style={{ marginTop: 12, fontSize: 46, fontWeight: 800, letterSpacing: -0.7 }}>
          User flow, sitemap, dan wireframe
        </div>
        <div style={{ marginTop: 8, fontSize: 18, color: colors.muted }}>
          Wireframe Figma — BLT-DD Prioritas · implementasi mengikuti susunan yang sama
        </div>

        <div style={{ display: 'flex', gap: 44, marginTop: 24 }}>
          <div
            style={{
              width: 980,
              padding: '22px 24px',
              borderRadius: 18,
              background: 'rgba(255, 251, 248, 0.88)',
              border: `1px solid ${colors.line}`,
              opacity: flowIn,
              transform: `translateY(${(1 - flowIn) * 22}px)`,
            }}
          >
            <div style={{ fontSize: 16, fontWeight: 800, color: colors.muted, letterSpacing: 1.4 }}>
              USER FLOW
            </div>
            <div style={{ display: 'flex', alignItems: 'center', marginTop: 16 }}>
              {flow.map((step, i) => (
                <React.Fragment key={step}>
                  <div
                    style={{
                      width: 160,
                      padding: '14px 8px',
                      borderRadius: 12,
                      textAlign: 'center',
                      background: i === 0 ? colors.maroon : colors.maroonSoft,
                      color: i === 0 ? '#FFF7F3' : colors.maroonDark,
                      border: `1px solid ${i === 0 ? colors.maroon : '#DDBFC5'}`,
                      fontSize: 17,
                      fontWeight: 750,
                    }}
                  >
                    {step}
                  </div>
                  {i < flow.length - 1 && (
                    <div style={{ flex: 1, textAlign: 'center', color: colors.maroon, fontSize: 22 }}>
                      →
                    </div>
                  )}
                </React.Fragment>
              ))}
            </div>
            <div style={{ marginTop: 14, fontSize: 15, color: colors.muted, lineHeight: 1.45 }}>
              Login gagal tetap di halaman login · Keluar mengakhiri sesi · Hasil dihitung dari nilai tersimpan.
            </div>
          </div>

          <div
            style={{
              flex: 1,
              padding: '22px 24px',
              borderRadius: 18,
              background: 'rgba(255, 251, 248, 0.88)',
              border: `1px solid ${colors.line}`,
              opacity: mapIn,
              transform: `translateY(${(1 - mapIn) * 22}px)`,
            }}
          >
            <div style={{ fontSize: 16, fontWeight: 800, color: colors.muted, letterSpacing: 1.4 }}>
              SITEMAP
            </div>
            <div style={{ marginTop: 12, display: 'flex', alignItems: 'center', gap: 10 }}>
              <div
                style={{
                  padding: '8px 16px',
                  borderRadius: 10,
                  background: colors.maroon,
                  color: '#FFF7F3',
                  fontSize: 15,
                  fontWeight: 750,
                }}
              >
                Login
              </div>
              <span style={{ color: colors.maroon, fontSize: 20 }}>→</span>
              <div
                style={{
                  padding: '8px 16px',
                  borderRadius: 10,
                  background: colors.maroonSoft,
                  color: colors.maroonDark,
                  fontSize: 15,
                  fontWeight: 750,
                  border: '1px solid #DDBFC5',
                }}
              >
                Beranda / App Shell
              </div>
            </div>
            <div style={{ marginLeft: 88, marginTop: 10, display: 'flex', gap: 8 }}>
              {['Data Calon', 'Penilaian', 'Hasil'].map((item) => (
                <div
                  key={item}
                  style={{
                    padding: '8px 10px',
                    borderRadius: 9,
                    background: '#FFFFFF',
                    border: `1px solid ${colors.line}`,
                    fontSize: 14,
                    fontWeight: 650,
                    textAlign: 'center',
                  }}
                >
                  {item}
                </div>
              ))}
            </div>
            <div style={{ marginTop: 12, fontSize: 14, color: colors.muted, lineHeight: 1.4 }}>
              Navigasi yang sama dipakai seluruh halaman. Breakpoint 760 px menentukan
              NavigationBar atau NavigationRail.
            </div>
          </div>
        </div>

        <div style={{ display: 'flex', gap: 26, marginTop: 20 }}>
          {wireframes.map((item, i) => {
            const enter = spring({
              frame: Math.max(0, frame - 24 - i * 7),
              fps,
              config: { damping: 200 },
            });
            return (
              <div
                key={item.src}
                style={{
                  width: 520,
                  opacity: enter,
                  transform: `translateY(${(1 - enter) * 26}px)`,
                }}
              >
                <div
                  style={{
                    fontSize: 16,
                    fontWeight: 750,
                    color: colors.muted,
                    marginBottom: 8,
                    paddingLeft: 4,
                  }}
                >
                  {item.label}
                </div>
                <div
                  style={{
                    borderRadius: 14,
                    overflow: 'hidden',
                    border: `1px solid ${colors.line}`,
                    background: '#FFFFFF',
                    boxShadow: '0 18px 38px rgba(64, 32, 40, 0.12)',
                  }}
                >
                  <Img
                    src={staticFile(item.src)}
                    style={{ width: '100%', display: 'block' }}
                  />
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </SceneChrome>
  );
};
