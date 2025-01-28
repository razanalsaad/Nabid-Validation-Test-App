//
//  SpeechAnalyzer.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 18/01/2025.
//

import Speech

final class SpeechAnalyzer: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode?
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioSession: AVAudioSession?
    
    
    @Published var recognizedText: String?
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String? // To display error messages in the UI


    func start() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Couldn't configure the audio session properly")
        }
        
        inputNode = audioEngine.inputNode
        
        speechRecognizer = SFSpeechRecognizer()
        print("Supports on device recognition: \(speechRecognizer?.supportsOnDeviceRecognition == true ? "✅" : "🔴")")

        // Force specified locale
//         self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ar-AE"))
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // Disable partial results
        // recognitionRequest?.shouldReportPartialResults = false
        
        // Enable on-device recognition
        // recognitionRequest?.requiresOnDeviceRecognition = true

        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable,
              let recognitionRequest = recognitionRequest,
              let inputNode = inputNode
        else {
            assertionFailure("Unable to start the speech recognition!")
            return
        }
        
        speechRecognizer.delegate = self
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            recognitionRequest.append(buffer)
        }

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            self?.recognizedText = result?.bestTranscription.formattedString
            
            guard error != nil || result?.isFinal == true else { return }
            self?.stop()
        }

        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            isProcessing = true
        } catch {
            handleError(error)
//            print("Coudn't start audio engine!")
//            stop()
        }
    }
    
    func stop() {
        recognitionTask?.cancel()
        
        audioEngine.stop()
        
        inputNode?.removeTap(onBus: 0)
        try? audioSession?.setActive(false)
        audioSession = nil
        inputNode = nil
        
        isProcessing = false
        
        recognitionRequest = nil
        recognitionTask = nil
        speechRecognizer = nil
    }
    
    private func handleError(_ error: Error) {
        stop() // Stop any ongoing processes
        
        // Map the error to a user friendly message
        if let speechError = error as? SpeechRecognitionError {
            errorMessage = speechError.localizedDescription
        } else {
            errorMessage = "An unexpected error occurred. Please try again."
        }
        
        print("Error: \(error.localizedDescription)") // Log the error for debugging
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("✅ Available")
        } else {
            print("🔴 Unavailable")
            recognizedText = "Text recognition unavailable. Sorry!"
            stop()
        }
    }
}

// Custom Error Enum for Speech Recognition Errors
enum SpeechRecognitionError: Error {
    case unavailableRecognizer
    case unableToCreateRequest
    case audioSessionConfigurationFailed
    case audioEngineStartupFailed
    
    var localizedDescription: String {
        switch self {
        case .unavailableRecognizer:
            return "Speech recognition is not available on this device or is currently unavailable."
        case .unableToCreateRequest:
            return "Failed to create a speech recognition request."
        case .audioSessionConfigurationFailed:
            return "Failed to configure the audio session."
        case .audioEngineStartupFailed:
            return "Could not start the audio engine."
        }
    }
}
