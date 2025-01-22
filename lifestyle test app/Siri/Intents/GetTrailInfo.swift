//
//  GetTrailInfo.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 22/01/2025.
//


//Abstract:
//An intent that outputs the details of a trail.
//*/

import Foundation
import AppIntents

struct GetTrailInfo: AppIntent {
    
    static var title: LocalizedStringResource = "Get challenge Information"
    static var description = IntentDescription("Provides complete details on a challenge",
                                               categoryName: "Discover")
    
   
    static var parameterSummary: some ParameterSummary {
        Summary("Get information on \(\.$challenge)")
    }

   
    @Parameter(title: "challenges", description: "The challenge to get information on.")
    var challenge: ChallengeEntity
    
    @Dependency
    private var mainViewModel: MainViewModel
    
   
    func perform() async throws -> some IntentResult & ReturnsValue<ChallengeEntity> & ProvidesDialog & ShowsSnippetView {
        let trailData = await mainViewModel.trail(with: challenge.id)
       
        let snippet = ChallengeDetailView(Challenge: trailData!)
        
        let dialog = IntentDialog(full: "The latest conditions reported for \(challenge.title) ",
                                  supporting: "Here's the latest information on trail conditions.")
        
        return .result(value: challenge, dialog: dialog, view: snippet)
    }
}

