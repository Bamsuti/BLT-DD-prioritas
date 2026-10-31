import fs from 'node:fs';
import path from 'node:path';
import { MsEdgeTTS, OUTPUT_FORMAT } from 'msedge-tts';
import { parseFile } from 'music-metadata';

const VOICE = 'id-ID-ArdiNeural';
const RATE = 0.95;
const PADDING_SECONDS = 2;
const END_HOLD_SECONDS = 3;

const root = path.resolve(import.meta.dirname, '..');
const narration = JSON.parse(
  fs.readFileSync(path.join(root, 'scripts', 'narration.json'), 'utf8'),
);
const audioDir = path.join(root, 'public', 'audio');
fs.mkdirSync(audioDir, { recursive: true });

const writeWithRetry = async (file, data) => {
  for (let attempt = 1; ; attempt++) {
    try {
      fs.writeFileSync(file, data);
      return;
    } catch (error) {
      if (attempt === 5) throw error;
      await new Promise((resolve) => setTimeout(resolve, 400));
    }
  }
};

const timing = [];

for (const scene of narration) {
  const tts = new MsEdgeTTS();
  await tts.setMetadata(VOICE, OUTPUT_FORMAT.AUDIO_24KHZ_96KBITRATE_MONO_MP3);
  const { audioStream } = tts.toStream(scene.text, { rate: RATE });

  const chunks = [];
  audioStream.on('data', (chunk) => chunks.push(chunk));
  await new Promise((resolve, reject) => {
    audioStream.on('close', resolve);
    audioStream.on('error', reject);
  });

  const file = path.join(audioDir, `${scene.id}.mp3`);
  await writeWithRetry(file, Buffer.concat(chunks));

  const meta = await parseFile(file);
  const audioSeconds = Number(meta.format.duration.toFixed(3));
  const padding =
    scene.id === narration[narration.length - 1].id
      ? END_HOLD_SECONDS
      : PADDING_SECONDS;

  timing.push({
    id: scene.id,
    title: scene.title,
    audio: audioSeconds,
    padding,
    duration: Number((audioSeconds + padding).toFixed(3)),
    captions: scene.captions,
  });

  console.log(
    `${scene.id}: audio ${audioSeconds}s + ${padding}s = ${(audioSeconds + padding).toFixed(2)}s`,
  );
}

const total = timing.reduce((sum, scene) => sum + scene.duration, 0);
await writeWithRetry(
  path.join(root, 'src', 'audio-timing.json'),
  JSON.stringify({ voice: VOICE, rate: RATE, totalSeconds: Number(total.toFixed(3)), scenes: timing }, null, 2) + '\n',
);
console.log(`total video: ${total.toFixed(2)}s`);
