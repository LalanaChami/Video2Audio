import Foundation
import AVFoundation
import Combine

class CameraViewModel: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    @Published var isRecording = false
    @Published var isProcessing = false
    @Published var hasExtractedAudio = false
    @Published var audioPlayer = AudioPlayerViewModel()

    let session = AVCaptureSession()
    private let videoOutput = AVCaptureMovieFileOutput()
    private var outputURL: URL {
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = UUID().uuidString + ".mov"
        return tempDir.appendingPathComponent(fileName)
    }

    func configureSession() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] videoGranted in
            guard videoGranted else {
                print("Camera access denied")
                return
            }
            
            AVCaptureDevice.requestAccess(for: .audio) { audioGranted in
                guard audioGranted else {
                    print("Microphone access denied")
                    return
                }
                
                DispatchQueue.main.async {
                    print("Configuring session")
                    self?.setupSession()
                }
            }
        }
    }

    private func setupSession() {
        session.beginConfiguration()
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get video device")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            } else {
                print("Failed to add video input")
                return
            }
        } catch {
            print("Error creating video input: \(error)")
            return
        }
        
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
            print("Failed to get audio device")
            return
        }
        
        do {
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if session.canAddInput(audioInput) {
                session.addInput(audioInput)
            } else {
                print("Failed to add audio input")
                return
            }
        } catch {
            print("Error creating audio input: \(error)")
            return
        }
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        } else {
            print("Failed to add video output")
            return
        }
        
        session.commitConfiguration()
        session.startRunning()
        print("Session started running")
    }

    func startRecording() {
        isRecording = true
        videoOutput.startRecording(to: outputURL, recordingDelegate: self)
    }

    func stopRecording() {
        isRecording = false
        videoOutput.stopRecording()
    }

    private func extractAudio(from videoURL: URL) {
        isProcessing = true

        let asset = AVURLAsset(url: videoURL)
        guard let audioTrack = asset.tracks(withMediaType: .audio).first else {
            isProcessing = false
            return
        }

        let composition = AVMutableComposition()
        let audioCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        do {
            try audioCompositionTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: audioTrack, at: .zero)
        } catch {
            print("Error inserting audio track: \(error)")
            isProcessing = false
            return
        }

        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("extracted_audio.m4a")
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try? FileManager.default.removeItem(at: outputURL)
        }

        guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A) else {
            isProcessing = false
            return
        }

        exporter.outputFileType = .m4a
        exporter.outputURL = outputURL
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                self.isProcessing = false
                if exporter.status == .completed {
                    self.hasExtractedAudio = true
                    self.audioPlayer.setAudioURL(url: outputURL)
                } else if let error = exporter.error {
                    print("Error exporting audio: \(error)")
                }
            }
        }
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Recording error: \(error)")
            return
        }
        extractAudio(from: outputFileURL)
    }
}
