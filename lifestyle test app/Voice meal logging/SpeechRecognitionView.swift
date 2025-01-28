//
//  SpeechRecognitionView.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 18/01/2025.
//

import SwiftUI

struct SpeechRecognitionView: View {
    private enum Constans {
        static let recognizeButtonSide: CGFloat = 100
    }
    
    @ObservedObject private var speechAnalyzer = SpeechAnalyzer()
    var body: some View {
        VStack {
            Spacer()
            if let errorMessage = speechAnalyzer.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Text(speechAnalyzer.recognizedText ?? "Tap to begin")
                .padding()
            
            Button {
                toggleSpeechRecognition()
            } label: {
                Image(systemName: speechAnalyzer.isProcessing ? "waveform.circle.fill" : "waveform.circle")
                    .resizable()
                    .frame(width: Constans.recognizeButtonSide,
                           height: Constans.recognizeButtonSide,
                           alignment: .center)
                    .foregroundColor(speechAnalyzer.isProcessing ? .red : .gray)
                    .aspectRatio(contentMode: .fit)
            }
            .padding()
        }
    }
}

private extension SpeechRecognitionView {
    func toggleSpeechRecognition() {
        if speechAnalyzer.isProcessing {
            speechAnalyzer.stop()
        } else {
            speechAnalyzer.start()
        }
    }
}
