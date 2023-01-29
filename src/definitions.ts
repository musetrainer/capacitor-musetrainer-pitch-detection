import type { PermissionState, PluginListenerHandle } from '@capacitor/core';

export type Pitch = {
  freq: number;
  amp: number;
  note: string;
  noteAlt: string;
};

export interface PermissionStatus {
  microphone: PermissionState;
}

export interface PitchDetectorPlugin {
  addListener(
    eventName: 'pitchReceive',
    listenerFunc: (pitch: Pitch) => void,
  ): Promise<PluginListenerHandle>;

  checkPermissions(): Promise<PermissionStatus>;
  requestPermissions(): Promise<PermissionStatus>;
}
