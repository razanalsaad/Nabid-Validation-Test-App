//
//  SleepEnvironmentOptimizer.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 27/01/2025.
//


import AVFoundation
import CoreMotion

class SleepEnvironmentOptimizer {
    private var motionManager = CMMotionManager()
    private var audioSession: AVAudioSession?

    // Variables for thresholds
    private let noiseThreshold: Double = 50.0 // Example threshold in decibels
    private let lightThreshold: Double = 300.0 // Example threshold in lux

    func startMonitoring() {
        // Start noise level monitoring
        monitorNoiseLevel()
        
        // Start light level monitoring
        monitorLightLevel()
    }

    // Function to monitor noise using the microphone
    func monitorNoiseLevel() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(.playAndRecord, mode: .default, options: .duckOthers)
            try audioSession?.setActive(true)

            // Start audio recorder for capturing noise
            let recorder = try AVAudioRecorder(url: URL(fileURLWithPath: "/dev/null"), settings: [:])
            recorder.isMeteringEnabled = true
            recorder.record()

            // Update noise level
            updateNoiseLevel(recorder)
        } catch {
            print("Error starting audio session: \(error)")
        }
    }

    func updateNoiseLevel(_ recorder: AVAudioRecorder) {
        recorder.updateMeters()
        let noiseLevel = recorder.averagePower(forChannel: 0) // Decibels
        
        if noiseLevel > noiseThreshold {
            recommendNoiseReduction()
        }
    }

    // Function to recommend noise reduction
    func recommendNoiseReduction() {
        print("Noise level is too high! Consider using earplugs or a white noise machine.")
    }

    // Function to monitor light levels (using the ambient light sensor)
    func monitorLightLevel() {
        // Assuming you have a sensor for light level (this part may vary based on device capabilities)
        // In this case, we'll use a hardcoded value for demonstration
        let lightLevel = 350.0 // Example lux value (typically fetched from a sensor)
        
        if lightLevel > lightThreshold {
            recommendDimLighting()
        }
    }

    // Function to recommend dimming lights
    func recommendDimLighting() {
        print("Light level is too high! Consider dimming the lights or using blackout curtains.")
    }
}
