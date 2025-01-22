//
//  ChallengeEntity.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 22/01/2025.
//


import Foundation
import AppIntents


struct ChallengeEntity: AppEntity {
    
    @Property(title: "Challenge Name")
    var title: String
    var content: String
    var id: Challenge.ID
    
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Challenge"

    //display the title and content
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)",
                              subtitle: "\(content)")
    }
    
    static var defaultQuery = ChallengeQuery()
    
    // Correctly initialize properties
    init(Challenge: Challenge) {
        self.id = Challenge.id
        self.content = Challenge.content
        self.title = Challenge.title
        
    }
}

struct ChallengeQuery: EntityQuery {
    @MainActor
    func entities(for identifiers: [ChallengeEntity.ID]) async throws -> [ChallengeEntity] {
        // Iterate over the identifiers and use trail(with:) to find the Challenges
        let Challenges = try await withThrowingTaskGroup(of: Challenge?.self) { group in
            for id in identifiers {
                group.addTask {
                    await MainViewModel.shared.trail(with: id) // Get the Challenge? for each identifier
                }
            }
            
            var results: [Challenge?] = []
            for try await Challenge in group {
                results.append(Challenge)
            }
            return results
        }
        
        // Map the Challenges to ChallengeEntity objects
        return Challenges.compactMap { $0 }.map { Challenge in
            ChallengeEntity(Challenge: Challenge)
        }
    }
}


extension ChallengeQuery: EnumerableEntityQuery {
        func allEntities() async throws -> [ChallengeEntity] {
            await MainViewModel.shared.storedChallenges.map {
                ChallengeEntity(Challenge: $0)
                
            }
        }
    
}

