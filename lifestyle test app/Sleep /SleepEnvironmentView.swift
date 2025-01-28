//
//  SleepEnvironmentView.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 27/01/2025.
//

import SwiftUI

struct SleepEnvironmentView: View {
    @StateObject private var analyzer = SleepEnvironmentAnalyzer()
    
    var body: some View {
        VStack {
            Text("Sleep Environment Optimization")
                .font(.title)
                .padding()
            
            // Display environment data
            Group {
                Text("Noise Level: \(analyzer.noiseLevel?.description ?? "N/A") dB")
                Text("Light Level: \(analyzer.lightLevel?.description ?? "N/A") lux")
                Text("Temperature: \(analyzer.temperature?.description ?? "N/A") °C")
            }
            .padding()
            
            // Display environment score
            Text("Environment Score: \(analyzer.environmentScore)")
                .font(.headline)
                .padding()
            
            // Display recommendations
            VStack(alignment: .leading) {
                Text("Recommendations:")
                    .font(.headline)
                ForEach(analyzer.recommendations, id: \.self) { recommendation in
                    Text("• \(recommendation)")
                }
            }
            .padding()
            
            // Error messages
            if let error = analyzer.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            // Start Monitoring Button
            Button("Start Monitoring") {
                analyzer.startMonitoring()
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct SleepEnvironmentView_Previews: PreviewProvider {
    static var previews: some View {
        SleepEnvironmentView()
    }
}
