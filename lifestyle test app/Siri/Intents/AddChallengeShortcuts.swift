//
//  AddChallengeShortcuts.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 22/01/2025.
//


import AppIntents

struct AddChallengeShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            //the intent will be from App Intent that we will define -- whole the process 
            intent: AddChallengeIntent(),
            phrases: [
                "Create a new \(.applicationName) challenge",
                "Start a new \(.applicationName) challenge",
                "Write a new \(.applicationName) challenge"
            ],
            shortTitle: "Add a Challenge",
            systemImageName: "pencil"
        )
        
        AppShortcut(
                       intent: OpenChallengeIntent(),
                       phrases: ["Open my challenge in  \(.applicationName) ",
                    "View my challenges in \(.applicationName) ",
                                 "Show me my challenges in  \(.applicationName) ",
                                
                                ],
                       shortTitle: "Open challenge",
                       systemImageName: "book"
                   )
        
        //
        /// `GetTrailInfo` allows people to quickly check the conditions on their favorite trails.
        AppShortcut(intent: GetTrailInfo(), phrases: [
            "Get \(\.$challenge) conditions with \(.applicationName)",
            "Get conditions on \(\.$challenge) with \(.applicationName)"
        ],
        shortTitle: "Get Conditions",
        systemImageName: "cloud.rainbow.half",
        parameterPresentation: ParameterPresentation(
            for: \.$challenge,
            summary: Summary("Get \(\.$challenge) conditions"),
            optionsCollections: {
                OptionsCollection(ChallengeQuery(), title: "Favorite Trails", systemImageName: "cloud.rainbow.half")
            }
        ))
        
    }
}
