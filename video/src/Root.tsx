import React from 'react';
import { Composition } from 'remotion';
import { loadFont } from '@remotion/fonts';
import { staticFile } from 'remotion';
import { BltPromo, FPS, totalFrames } from './Video';

loadFont({
  family: 'Plus Jakarta Sans',
  url: staticFile('fonts/PlusJakartaSans.ttf'),
  weight: '200 800',
});

export const RemotionRoot: React.FC = () => {
  return (
    <Composition
      id="BltPromo"
      component={BltPromo}
      durationInFrames={totalFrames}
      fps={FPS}
      width={1920}
      height={1080}
    />
  );
};
