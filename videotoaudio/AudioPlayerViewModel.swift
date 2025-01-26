import Foundation
import AVFoundation

class AudioPlayerViewModel: NSObject, ObservableObject {
    private var player: AVAudioPlayer?

    @Published var isPlaying = false

    func setAudioURL(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
        } catch {
            print("Error setting audio URL: \(error)")
        }
    }

    func play() {
        player?.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func stop() {
        player?.stop()
        player?.currentTime = 0
        isPlaying = false
    }
}

extension AudioPlayerViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
