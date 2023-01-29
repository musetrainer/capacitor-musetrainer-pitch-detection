import { registerPlugin } from '@capacitor/core';

import type { PitchDetectorPlugin } from './definitions';

const PitchDetector = registerPlugin<PitchDetectorPlugin>('PitchDetector', {
  web: () => import('./web').then(m => new m.PitchDetectorWeb()),
});

export * from './definitions';
export { PitchDetector };
