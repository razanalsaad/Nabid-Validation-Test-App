//
//  MapWithTasksView.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 20/01/2025.
//

import SwiftUI
import MapKit

struct Task {
    let name: String
    let date: Date
    var isDone: Bool
}

struct WeeklyChallenge: Identifiable {
    let id: UUID
    
    let location: CLLocationCoordinate2D
    var days: [Day]
}

struct Day {
    let date: Date
    var tasks: [Task]
}


struct MapWithTasksView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Example coordinates (San Francisco)
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    let weeklyChallenges: [WeeklyChallenge] = {
        var challenges = [WeeklyChallenge]()
        let sampleTasks = [
            Task(name: "Task yay \(Int.random(in: 1...100))", date: Date(), isDone: false),
            Task(name: "Task \(Int.random(in: 1...100))", date: Date(), isDone: false),
            Task(name: "Task okay \(Int.random(in: 1...100))", date: Date(), isDone: false)
        ]
        
        for i in 1...10 {
            let days = (0..<7).map { offset in
                Day(date: Calendar.current.date(byAdding: .day, value: offset, to: Date())!, tasks: sampleTasks)
            }
            let challenge = WeeklyChallenge(
                id: UUID(), location: CLLocationCoordinate2D(latitude: 37.7749 + Double(i) * 0.01, longitude: -122.4194 + Double(i) * 0.01),
                days: days
            )
            challenges.append(challenge)
        }
        
        return challenges
    }()
    
    var selectedChallenge: WeeklyChallenge {
        weeklyChallenges.first! // Using the first challenge as an example
    }
    
    var body: some View {
        VStack {
            // Map Section
            Map(coordinateRegion: $region, annotationItems: [selectedChallenge]) { challenge in
                MapAnnotation(coordinate: challenge.location) {
                    VStack {
                        Image(systemName: "location.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                            .shadow(radius: 5)
                        
                        Text("Challenge 1")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            }
            .cornerRadius(15)
            .onAppear {
                region.center = selectedChallenge.location
            }
            
            HStack{
                Text("Week 1 Challenge")
                    .font(.largeTitle)
                    .padding(.bottom, 5)
                Spacer()
                
            }
            .padding(.leading)
            
            // Content Below Map
            HStack(alignment: .top) {
                // Task List
                VStack(alignment: .leading) {
                    ForEach(selectedChallenge.days[0].tasks.indices, id: \.self) { index in
                        HStack {
                            Image(systemName: selectedChallenge.days[0].tasks[index].isDone ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedChallenge.days[0].tasks[index].isDone ? .green : .blue)
                            Text(selectedChallenge.days[0].tasks[index].name)
                                .font(.body)
                            Spacer()
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .frame(maxWidth: 0.4 * UIScreen.main.bounds.width)
                
                Spacer()
                
                // Directions Section
                VStack(alignment: .trailing) {
                    ForEach(["Turn right", "Walk 100m","Walk 100m","Walk 100m", "Arrive at destination"], id: \.self) { direction in
                        HStack {
                            Text(direction)
                                .font(.body)
                            Image("distnation")
                                .resizable()
                                .frame(width: 18, height: 18)
                        }
                        .padding(.bottom, 2)
                    }
                }
                .frame(maxWidth: 0.55 * UIScreen.main.bounds.width)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.top) // Let the map stretch to the top edge
    }
}

struct MapWithTasksView_Previews: PreviewProvider {
    static var previews: some View {
        MapWithTasksView()
    }
}
