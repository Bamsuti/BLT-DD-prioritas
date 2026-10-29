export const colors = {
  bg: '#F7F2EF',
  bgDeep: '#EFE3DE',
  maroon: '#7A1C2E',
  maroonDark: '#5A1220',
  maroonSoft: '#F3E2E5',
  ink: '#241B1F',
  muted: '#6E6064',
  line: '#E2D5D0',
  cream: '#FFFBF8',
  success: '#2E6B4F',
  warning: '#8A5A1F',
  warningBg: '#FBF0DD',
};

export const fontFamily = '"Plus Jakarta Sans", "Segoe UI", sans-serif';

export type SceneTiming = {
  id: string;
  title: string;
  audio: number;
  padding: number;
  duration: number;
  captions: string[];
};
