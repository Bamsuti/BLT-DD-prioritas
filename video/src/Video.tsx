import React from 'react';
import { AbsoluteFill, Audio, Sequence, staticFile } from 'remotion';
import timing from './audio-timing.json';
import { IntroScene } from './scenes/IntroScene';
import { ProblemScene } from './scenes/ProblemScene';
import { NeedsScene } from './scenes/NeedsScene';
import { DesignScene } from './scenes/DesignScene';
import { DemoScene } from './scenes/DemoScene';
import { ResponsiveScene } from './scenes/ResponsiveScene';
import { TechScene } from './scenes/TechScene';
import { ClosingScene } from './scenes/ClosingScene';
import { colors, type SceneTiming } from './theme';

export const FPS = 30;

const scenes = timing.scenes as SceneTiming[];

export const sceneFrames = (scene: SceneTiming) =>
  Math.round(scene.duration * FPS);

export const totalFrames = scenes.reduce(
  (sum, scene) => sum + sceneFrames(scene),
  0,
);

const renderScene = (scene: SceneTiming, index: number) => {
  const props = { scene, index, total: scenes.length };
  switch (scene.id) {
    case 'scene-01':
      return <IntroScene {...props} />;
    case 'scene-02':
      return <ProblemScene {...props} />;
    case 'scene-03':
      return <NeedsScene {...props} />;
    case 'scene-04':
      return <DesignScene {...props} />;
    case 'scene-05':
      return <DemoScene {...props} />;
    case 'scene-06':
      return <ResponsiveScene {...props} />;
    case 'scene-07':
      return <TechScene {...props} />;
    case 'scene-08':
      return <ClosingScene {...props} />;
    default:
      return null;
  }
};

export const BltPromo: React.FC = () => {
  let from = 0;

  return (
    <AbsoluteFill style={{ backgroundColor: colors.bg }}>
      {scenes.map((scene, index) => {
        const durationInFrames = sceneFrames(scene);
        const offset = from;
        from += durationInFrames;

        return (
          <Sequence
            key={scene.id}
            name={`${scene.id} · ${scene.title}`}
            from={offset}
            durationInFrames={durationInFrames}
          >
            {renderScene(scene, index)}
            <Audio src={staticFile(`audio/${scene.id}.mp3`)} />
          </Sequence>
        );
      })}
    </AbsoluteFill>
  );
};
