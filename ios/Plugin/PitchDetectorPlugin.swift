import Foundation
import Capacitor
import AVFoundation
import AudioKit


class PitchData: NSObject {
    var frequency: Float = 0.0
    var amplitude: Float = 0.0
    var noteWithSharps = "-"
    var noteWithFlats = "-"
}

@objc(PitchDetectorPlugin)
public class PitchDetectorPlugin: CAPPlugin {
    var data = PitchData()
    
    var engine = AudioEngine()
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    func listen() {
        guard let input = engine.input else { fatalError() }
        engine.output = Mixer(input)

        let tracker = PitchTap(input) { freq, amp in
            DispatchQueue.main.async {
                self.update(freq[0], amp[0])
                self.notify()
            }
        }
        tracker.start()
        try? engine.start()
    }
    
    func notify() {
        self.notifyListeners("pitchReceive", data: [
            "freq": data.frequency,
            "amp": data.amplitude,
            "note": data.noteWithSharps,
            "noteAlt": data.noteWithFlats,
        ])
    }
    
    func update(_ freq: AUValue, _ amp: AUValue) {
        guard amp > 0.1 else { return }

        data.frequency = freq
        data.amplitude = amp

        var frequency = freq
        while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
            frequency /= 2.0
        }
        while frequency < Float(noteFrequencies[0]) {
            frequency *= 2.0
        }

        var minDistance: Float = 10000.0
        var index = 0

        for possibleIndex in 0 ..< noteFrequencies.count {
            let distance = fabsf(Float(noteFrequencies[possibleIndex]) - frequency)
            if distance < minDistance {
                index = possibleIndex
                minDistance = distance
            }
        }
        let octave = Int(log2f(freq / frequency))
        
        data.noteWithSharps = "\(noteNamesWithSharps[index])\(octave)"
        data.noteWithFlats = "\(noteNamesWithFlats[index])\(octave)"
    }
    
    @objc override public func requestPermissions(_ call: CAPPluginCall) {
        let group = DispatchGroup()

        group.enter()
        AVCaptureDevice.requestAccess(for: .audio) { _ in
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.checkPermissions(call)
        }
    }
    
    @objc override public func checkPermissions(_ call: CAPPluginCall) {
        var perm = ""
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .denied, .restricted:
            perm = "denied"
        case .authorized:
            perm = "granted"
            self.listen()
        case .notDetermined:
            fallthrough
        @unknown default:
            perm = "prompt"
        }
        
        call.resolve(["microphone": perm])
    }
}
