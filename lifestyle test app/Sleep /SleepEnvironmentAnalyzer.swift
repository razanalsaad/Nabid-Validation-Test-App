//
//  SleepEnvironmentAnalyzer.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 27/01/2025.
//


import SwiftUI
import AVFoundation
import CoreMotion

final class SleepEnvironmentAnalyzer: ObservableObject {
    // MARK: - Properties
    private let audioRecorder = AVAudioRecorder()
    private let lightSensor = CMMotionManager()
    
    @Published var noiseLevel: Double? = nil
    @Published var lightLevel: Double? = nil
    @Published var temperature: Double? = nil
    @Published var environmentScore: String = "Unknown"
    @Published var recommendations: [String] = []
    @Published var errorMessage: String? = nil
    
    // MARK: - Thresholds
    private let idealNoiseLevel = 30.0 // dB
    private let idealLightLevel = 5.0 // lux
    private let idealTempRange = 16.0...20.0 // Celsius
    
    // MARK: - Functions
    func startMonitoring() {
        monitorNoise()
        monitorLight()
        calculateEnvironmentScore()
    }
    
    // Monitor ambient noise levels
    private func monitorNoise() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true)
            
            // Assume microphone data processing for simplicity
            // Replace with actual decibel measurement implementation
            noiseLevel = Double.random(in: 20...50) // Simulated noise level
        } catch {
            errorMessage = "Unable to access microphone for noise monitoring."
        }
    }
    
    // Monitor ambient light levels
    private func monitorLight() {
        if lightSensor.isDeviceMotionAvailable {
            lightSensor.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] data, error in
                if let error = error {
                    self?.errorMessage = "Light sensor error: \(error.localizedDescription)"
                    return
                }
                // Simulate light levels as CoreMotion doesn't directly provide light data
                self?.lightLevel = Double.random(in: 1...10)
            }
        } else {
            errorMessage = "Light sensor is unavailable on this device."
        }
    }
    
    // Calculate environment score based on inputs
    private func calculateEnvironmentScore() {
        var score = 100
        var recommendations = [String]()
        
        // Noise level evaluation
        if let noise = noiseLevel {
            if noise > idealNoiseLevel {
                score -= 30
                recommendations.append("Reduce noise. Consider earplugs or soundproofing.")
            }
        } else {
            recommendations.append("Noise level data is unavailable.")
        }
        
        // Light level evaluation
        if let light = lightLevel {
            if light > idealLightLevel {
                score -= 20
                recommendations.append("Reduce light. Use blackout curtains or a sleep mask.")
            }
        } else {
            recommendations.append("Light level data is unavailable.")
        }
        
        // Temperature evaluation
        if let temp = temperature {
            if !idealTempRange.contains(temp) {
                score -= 20
                recommendations.append("Adjust room temperature to 16-20°C.")
            }
        } else {
            recommendations.append("Temperature data is unavailable.")
        }
        
        // Update properties
        environmentScore = "\(score)%"
        self.recommendations = recommendations
    }
}

