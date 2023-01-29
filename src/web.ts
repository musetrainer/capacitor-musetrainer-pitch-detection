/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/ban-ts-comment */
import type { ListenerCallback, PluginListenerHandle } from '@capacitor/core';
import { WebPlugin } from '@capacitor/core';

import type { PitchDetectorPlugin, PermissionStatus } from './definitions';

export class PitchDetectorWeb extends WebPlugin implements PitchDetectorPlugin {
  async addListener(
    _eventName: string,
    _listenerFunc: ListenerCallback,
    // @ts-ignore https://github.com/typescript-eslint/typescript-eslint/issues/2034
  ): Promise<PluginListenerHandle> & PluginListenerHandle {
    throw this.unimplemented('Not implemented on web.');
  }

  async checkPermissions(): Promise<PermissionStatus> {
    throw this.unimplemented('Not implemented on web.');
  }

  async requestPermissions(): Promise<PermissionStatus> {
    throw this.unimplemented('Not implemented on web.');
  }
}
