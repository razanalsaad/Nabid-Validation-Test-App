//
//  SiriView.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 22/01/2025.
//



import SwiftUI
import AppIntents


struct SiriView: View {
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject private var viewModel = MainViewModel.shared
    @State private var isPresented: Bool = false
    @State private var ChallengeString: String = ""
    @State private var contenteString: String = ""
    @State private var tipIsShown = true // Showing the tips

    var body: some View {
        NavigationStack {
            SiriTipView(
                intent: AddChallengeIntent(),
                isVisible: $tipIsShown
            )
            
            VStack {
                List {
                    ForEach(viewModel.storedChallenges) { Challenge in
                        Button(action: {
                            viewModel.selectedChallenge = Challenge
                            viewModel.showChallengeDetail = true // Activate navigation to ChallengeDetailView
                        }) {
                            VStack(alignment: .leading) {
                                Text(Challenge.title)
                                    .font(.headline)
                                Text(Challenge.content)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        viewModel.deleteValuesFromUserDefaults(indexSet: indexSet)
                    })
                }
                .navigationTitle("Challenges")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { isPresented.toggle() }) {
                            HStack {
                                Text("Add Challenge")
                                Image(systemName: "plus")
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) { EditButton() }
                }
                .sheet(isPresented: $isPresented) {
                    VStack {
                        TextField("Add your Challenge title...", text: $ChallengeString)
                            .padding()
                        TextField("Add your Challenge content...", text: $contenteString)
                            .padding()
                        
                        Section {
                            Button("Add") {
                                let newChallenge = Challenge(title: ChallengeString, content: contenteString)
                                viewModel.writeValuesToUserDefaults(Challenge: newChallenge)
                                isPresented.toggle()
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding()
                }
                // Bind showChallengeDetail for programmatically navigating to ChallengeDetailView
                .background(
                    NavigationLink(
                        destination: ChallengeDetailView(Challenge: (viewModel.selectedChallenge ?? viewModel.storedChallenges.first) ?? Challenge(title: "Title", content: "Somthing")),
                        isActive: $viewModel.showChallengeDetail
                    ) {
                        EmptyView()
                    }
                )
                .onAppear {
                    viewModel.readValuesFromUserDefaults()
                }
                .onChange(of: scenePhase) { _ in
                    viewModel.readValuesFromUserDefaults()
                }
                
                ShortcutsLink()
            }
        }
    }
}

#Preview {
    SiriView()
}

struct ChallengeDetailView: View {
    let Challenge: Challenge
    @ObservedObject var viewModel = MainViewModel.shared
    var body: some View {
        VStack(alignment: .leading) {
            Text(Challenge.title)
                .font(.largeTitle)
                .padding(.bottom)
            
            Text(Challenge.content)
                .font(.body)
                .padding(.bottom)
        }
        .padding()
        .navigationTitle(Challenge.title)
    }
}
