import SwiftUI
import AVFoundation

struct CustomCameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var showBottomSheet = false

    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.session)
                .edgesIgnoringSafeArea(.all)
                .border(Color.blue, width: 2)
                
            VStack {
                Spacer()
                if viewModel.isProcessing {
                    ProgressView("Extracting Audio...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                
                Button(action: {
                    if viewModel.isRecording {
                        viewModel.stopRecording()
                    } else {
                        viewModel.startRecording()
                    }
                }) {
                    Text(viewModel.isRecording ? "Stop Recording" : "Start Recording")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            viewModel.configureSession()
        }
        .onChange(of: viewModel.isRecording) { isRecording in
//            if !isRecording && viewModel.hasExtractedAudio {
//                showBottomSheet = true
//            }
            if !isRecording  {
                showBottomSheet = true
            }
        }
        .sheet(isPresented: $showBottomSheet) {
            AudioPlayerView(audioPlayer: viewModel.audioPlayer, isPresented: $showBottomSheet)
        }
    }
}



struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        print("Creating UIView for CameraPreview")
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        context.coordinator.previewLayer = previewLayer
        view.layer.addSublayer(previewLayer)
        view.backgroundColor = .black // Set a background color for visibility
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let previewLayer = context.coordinator.previewLayer else {
            print("Preview layer is nil in updateUIView")
            return
        }
        DispatchQueue.main.async {
            previewLayer.frame = uiView.bounds
            print("Updated UIView for CameraPreview with frame: \(uiView.bounds)")
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var previewLayer: AVCaptureVideoPreviewLayer?
    }
}
