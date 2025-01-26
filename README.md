# Video2Audio - Custom Camera and Audio Extraction App

This SwiftUI app allows users to record videos using the device's camera and extract audio from the recorded videos. The app features a custom camera interface with recording controls and a bottom sheet that plays the extracted audio with play, pause, and stop controls.

## Features

- **Custom Camera Interface**: Uses `AVCaptureSession` for video recording and displays the camera preview using `AVCaptureVideoPreviewLayer`.
- **Recording Controls**: Allows users to start and stop video recording with a single button.
- **Audio Extraction**: Extracts audio from the recorded video using `AVAssetExportSession` and saves it as an `.m4a` file.
- **Audio Playback**: Presents a bottom sheet with controls to play, pause, and stop the extracted audio.
- **Seamless Transitions**: Ensures smooth transitions between different views and components.

## Code Overview

### CustomCameraView.swift
- **CustomCameraView**: The main SwiftUI view that displays the camera preview and recording controls.
- **CameraPreview**: A `UIViewRepresentable` that wraps `AVCaptureVideoPreviewLayer` to show the camera feed.
- **AudioPlayerView**: A SwiftUI view that presents the audio playback controls in a bottom sheet.

### CameraViewModel.swift
- **CameraViewModel**: An `ObservableObject` that manages the camera session, recording, and audio extraction processes.
- **configureSession()**: Configures the camera session with video and audio inputs.
- **startRecording()**: Starts video recording.
- **stopRecording()**: Stops video recording and initiates audio extraction.
- **extractAudio(from:)**: Extracts audio from the recorded video and prepares it for playback.

### AudioPlayer.swift
- **AudioPlayer**: A class that manages audio playback using `AVAudioPlayer`.
- **setAudioURL(url:)**: Sets the audio file URL for playback.
- **play()**: Starts audio playback.
- **pause()**: Pauses audio playback.
- **stop()**: Stops audio playback and resets the playback position.

### SplashScreenView.swift (Optional)
- **SplashScreenView**: An optional SwiftUI view that can be used as a splash screen to enhance the app's launch experience.

## Getting Started

1. **Clone the Repository**: 
    ```sh
    git clone <repository-url>
    ```
2. **Open in Xcode**: Open the `.xcodeproj` or `.xcworkspace` file in Xcode.
3. **Run the App**: Select a target device or simulator and run the app.

## Requirements

- iOS 14.0+
- Xcode 12.0+

## License

This project is licensed under the MIT License. See the LICENSE file for details.