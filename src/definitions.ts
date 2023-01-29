import type { PluginListenerHandle } from '@capacitor/core';

export type Pitch = {
  freq: number;
  amp: number;
};

export interface PitchDetectorPlugin {
  addListener(
    eventName: 'pitchReceive',
    listenerFunc: (pitch: Pitch) => void,
  ): Promise<PluginListenerHandle>;
}
