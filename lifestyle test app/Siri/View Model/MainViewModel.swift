//
//  MainViewModel.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 22/01/2025.
//


import Foundation

struct Challenge: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let content: String
  
    
    
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
    }
   
}

@MainActor
class MainViewModel: ObservableObject, Sendable {
    @Published var storedChallenges: [Challenge] = []
    @Published var selectedChallenge: Challenge?
    private let keyStoredChallenges = "storedChallenges"
    //to observed all the main 
    static let shared = MainViewModel()
    @Published var showChallengeDetail: Bool = false
    
     init() {
          readValuesFromUserDefaults()
       }
    func readValuesFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: keyStoredChallenges) {
            if let decodedData = try? JSONDecoder().decode([Challenge].self, from: data) {
                storedChallenges = decodedData
            }
        }
    }
    //get the Challenge by Id
    func openChallengeByID(_ id: UUID) -> Challenge? {
         
           return storedChallenges.first { $0.id == id }
       }
    
    func trail(with identifier: Challenge.ID) -> Challenge? {
        return storedChallenges.first { $0.id == identifier }
    }
    
//    func navigate(to id: UUID) {
//        // Find the Challenge by ID and set it as the selected Challenge
//        if let Challenge = storedChallenges.first(where: { $0.id == id }) {
//            DispatchQueue.main.async {
//                self.selectedChallenge = Challenge
//                // Print for debugging
//                print("Navigating to Challenge with title: \(Challenge.title)")
//            }
//        }
//    }
    
    func navigate(to id: UUID) {
            if let Challenge = storedChallenges.first(where: { $0.id == id }) {
                DispatchQueue.main.async {
                    self.selectedChallenge = Challenge
                    self.showChallengeDetail = true // Activate navigation
                    print("Navigating to Challenge with title: \(Challenge.title)")
                }
            }
        }

///Friday Tring
    func openChallengeAndNavigate(by id: UUID) {
    if let Challenge = storedChallenges.first(where: { $0.id == id }) {
        DispatchQueue.main.async {
            self.selectedChallenge = Challenge
            print("Navigating to Challenge with title: \(Challenge.title)")
        }
    } else {
        print("Challenge with ID \(id) not found.")
    }
}
   
    func writeValuesToUserDefaults(Challenge: Challenge) {
        readValuesFromUserDefaults()
        storedChallenges.append(Challenge)
        if let encodedData = try? JSONEncoder().encode(storedChallenges) {
            UserDefaults.standard.set(encodedData, forKey: keyStoredChallenges)
        }
    }
    
    func deleteValuesFromUserDefaults(indexSet: IndexSet) {
        storedChallenges.remove(atOffsets: indexSet)
        if let encodedData = try? JSONEncoder().encode(storedChallenges) {
            UserDefaults.standard.set(encodedData, forKey: keyStoredChallenges)
        }
    }
}
