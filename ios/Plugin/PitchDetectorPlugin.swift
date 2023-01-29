import Foundation
import Capacitor


@objc(PitchDetectorPlugin)
public class PitchDetectorPlugin: CAPPlugin {
    var detector = PitchDetector()
    var observer: NSKeyValueObservation?

    override public func load() {
        observer = self.observe(\.detector.data) { (_, pitch) in
            self.notifyListeners("pitchReceive", data: [
                "freq": pitch.newValue?.frequency ?? 0,
                "amp": pitch.newValue?.amplitude ?? 0,
            ])
        }
    }
}
