//
//  OpenChallengeIntent.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 22/01/2025.
//


import Foundation
import AppIntents
import SwiftUI

struct OpenChallengeIntent: AppIntent,OpenIntent {
    static var title: LocalizedStringResource = "Open Challenge with parameter"
    //the name showen in the parameter that user would like ro select
    @Parameter(title: "Challenges")
    //the entity it mean the options"my Challenges list "
    var target: ChallengeEntity
    func perform() async throws -> some IntentResult {
        await MainViewModel.shared.navigate(to:target.id)
        return .result()
    }
    //to create the summary
    static var parameterSummary: some ParameterSummary {
        Summary("Open\(\.$target)")
        
    }
}

