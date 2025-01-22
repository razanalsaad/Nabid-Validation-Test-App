//
//  ChallengeAddedView.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 22/01/2025.
//


import AppIntents
import SwiftUI

struct ChallengeAddedView: View {
    let Challenge: Challenge

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Challenge Added")
                .font(.headline)
            Text("Title: \(Challenge.title)")
                .font(.subheadline)
            Text("Content: \(Challenge.content)")
                .font(.body)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
//here with deafult siri view
//struct AddChallengeIntent: AppIntent {
//    static let title: LocalizedStringResource = "Add a Challenge with Siri"
//    
//    @Parameter(title: "Challenge Title")
//    var ChallengeTitle: String
//    
//    @Parameter(title: "Challenge Content")
//    var ChallengeContent: String
//    
//    // This method will be triggered by Siri to add the Challenge
//    func perform() async throws -> some IntentResult & ProvidesDialog {
//        // Create a MainViewModel instance
//        let viewModel = MainViewModel()
//        
//        // Create a new Challenge with the provided title and content
//        let newChallenge = Challenge(title: ChallengeTitle, content: ChallengeContent)
//        
//        // Save the Challenge using the viewModel
//        viewModel.writeValuesToUserDefaults(Challenge: newChallenge)
//        
//        // Provide feedback to the user through Siri
//        return .result(dialog: "Your challenge has been saved.")
//    }
//}

//here with custom view

struct AddChallengeIntent: AppIntent {
    static let title: LocalizedStringResource = "Add a Challenge with Siri"
    
    @Parameter(title: "Challenge Title")
    var ChallengeTitle: String
    
    @Parameter(title: "Challenge Content")
    var ChallengeContent: String
    
    

    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        // Create a MainViewModel instance
        let viewModel = await MainViewModel()
          
        // Create a new Challenge with the provided title, and content
        let newChallenge = Challenge(title: ChallengeTitle, content: ChallengeContent)

        // Save the Challenge using the viewModel
        await viewModel.writeValuesToUserDefaults(Challenge: newChallenge)

        // Provide feedback to the user through Siri
        let dialog = IntentDialog("Your Challenge has been saved successfully.")

        // Return a custom SwiftUI view showing the Challenge
        let snippetView = ChallengeAddedView(Challenge: newChallenge)

        return .result(dialog: dialog, view: snippetView)
    }
}

