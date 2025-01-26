//
//  SplashScreenView.swift
//  videotoaudio
//
//  Created by Lalana Thanthirigama on 2025-01-26.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            CustomCameraView()
        } else {
            VStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                Text("Extract Audio")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
