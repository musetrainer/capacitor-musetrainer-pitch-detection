/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/ban-ts-comment */
import type { ListenerCallback, PluginListenerHandle } from '@capacitor/core';
import { WebPlugin } from '@capacitor/core';

import type { PitchDetectorPlugin } from './definitions';

export class PitchDetectorWeb extends WebPlugin implements PitchDetectorPlugin {
  async addListener(
    _eventName: string,
    _listenerFunc: ListenerCallback,
    // @ts-ignore https://github.com/typescript-eslint/typescript-eslint/issues/2034
  ): Promise<PluginListenerHandle> & PluginListenerHandle {
    return {
      remove: async () => {
        // TODO: Implement me!
      },
    };
  }
}
