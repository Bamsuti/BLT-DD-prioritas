import React from 'react';
import { Img, staticFile } from 'remotion';
import { colors, fontFamily } from '../theme';

type ScreenshotFrameProps = {
  src: string;
  label: string;
  width: number;
  rotate?: number;
  style?: React.CSSProperties;
};

export const ScreenshotFrame: React.FC<ScreenshotFrameProps> = ({
  src,
  label,
  width,
  rotate = 0,
  style,
}) => {
  return (
    <div
      style={{
        width,
        borderRadius: 18,
        background: '#FFFFFF',
        border: `1px solid ${colors.line}`,
        boxShadow: '0 30px 70px rgba(64, 32, 40, 0.20)',
        overflow: 'hidden',
        transform: `rotate(${rotate}deg)`,
        fontFamily,
        ...style,
      }}
    >
      <div
        style={{
          height: 46,
          display: 'flex',
          alignItems: 'center',
          gap: 9,
          padding: '0 18px',
          background: '#FBF7F4',
          borderBottom: `1px solid ${colors.line}`,
        }}
      >
        <span style={{ width: 11, height: 11, borderRadius: '50%', background: '#D9B8B2' }} />
        <span style={{ width: 11, height: 11, borderRadius: '50%', background: '#E5CFC0' }} />
        <span style={{ width: 11, height: 11, borderRadius: '50%', background: '#D8CBC4' }} />
        <span
          style={{
            marginLeft: 12,
            fontSize: 14,
            color: colors.muted,
            fontWeight: 600,
            letterSpacing: 0.6,
          }}
        >
          {label}
        </span>
      </div>
      <Img src={staticFile(src)} style={{ width: '100%', display: 'block' }} />
    </div>
  );
};
