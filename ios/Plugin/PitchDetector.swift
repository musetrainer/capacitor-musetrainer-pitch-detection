import Foundation
import AudioKit


class PitchData: NSObject {
    var frequency: Float = 0.0
    var amplitude: Float = 0.0
}

@objc public class PitchDetector: NSObject {
    @objc dynamic var data = PitchData()
    
    var engine = AudioEngine()
    let initialDevice: Device
    
    let mic: AudioEngine.InputNode
    let tappableNodeA: Fader
    let tappableNodeB: Fader
    let tappableNodeC: Fader
    let silence: Fader
    
    var tracker: PitchTap!
    
    override init() {
        guard let input = engine.input else { fatalError() }
        
        guard let device = engine.inputDevice else { fatalError() }
        
        initialDevice = device
        
        mic = input
        tappableNodeA = Fader(mic)
        tappableNodeB = Fader(tappableNodeA)
        tappableNodeC = Fader(tappableNodeB)
        silence = Fader(tappableNodeC, gain: 0)
        engine.output = silence
        
        super.init()
        
        tracker = PitchTap(mic) { freq, amp in
            DispatchQueue.main.async {
                self.update(freq[0], amp[0])
            }
        }
        tracker.start()
    }
    
    func update(_ freq: AUValue, _ amp: AUValue) {
        data.frequency = freq
        data.amplitude = amp
    }
}
