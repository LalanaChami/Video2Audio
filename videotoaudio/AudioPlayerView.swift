//
//  AudioPlayerView.swift
//  videotoaudio
//
//  Created by Lalana Thanthirigama on 2025-01-26.
//

import SwiftUI

struct AudioPlayerView: View {
    @ObservedObject var audioPlayer: AudioPlayerViewModel
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            HStack {
                Text("Extracted Audio")
                    .font(.title)
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding()

            Spacer()

            HStack {
                if audioPlayer.isPlaying {
                    Button(action: {
                        audioPlayer.pause()
                    }) {
                        HStack {
                            Image(systemName: "pause.circle.fill")
                                .font(.largeTitle)
                            Text("Pause")
                                .font(.title2)
                        }
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                    }
                } else {
                    Button(action: {
                        audioPlayer.play()
                    }) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .font(.largeTitle)
                            Text("Play")
                                .font(.title2)
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                }
                Button(action: {
                    audioPlayer.stop()
                }) {
                    HStack {
                        Image(systemName: "stop.circle.fill")
                            .font(.largeTitle)
                        Text("Stop")
                            .font(.title2)
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
            }

            Spacer()
        }
        .padding()
    }
}
