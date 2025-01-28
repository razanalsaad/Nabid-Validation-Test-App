//
//  ContentView.swift
//  lifestyle test app
//
//  Created by Gehad Eid on 06/01/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapWithTasksView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Map")
                }
            
            SpeechRecognitionView()
                .tabItem {
                    Label("Voice logging", systemImage: "2.circle")
                }
            
            SiriView()
                .tabItem {
                    Label("Siri", systemImage: "3.circle")
                }
            
            SleepEnvironmentView()
                .tabItem {
                    Label("Sleep", systemImage: "4.circle")
                }
            
            // Add ur views here ---
            
        }
    }
}

#Preview {
    ContentView()
}













//
//
//import Alamofire
//
//struct FoodProductResponse: Decodable {
//    let code: Int
//    let name: String
//    let data: FoodProductData?
//}
//
//struct FoodProductData: Decodable {
//    let result: FoodProduct?
//}
//
//struct FoodProduct: Decodable {
//    let id: Int
//    let bayaN_ID: Int
//    let referanceNumber: String
//    let arStatus: String
//    let enStatus: String
//    let brandName: String
//    let tradeName: String
//    let hsCode: String
//    let itemWeight: Int
//    let unitNameEn: String
//    let enCOProduction: String
//    let storageTemperatureEn: String
//    let ingredientsEn: String?
//}
//
//func fetchFoodProductWithErrorHandling(barcode: String, completion: @escaping (Result<FoodProduct, String>) -> Void) {
//    let apiUrl = "https://apis.sfda.gov.sa:9002/v2/Food"
//    let parameters: [String: Any] = [
//        "barCode": barcode
//    ]
//
//    AF.request(apiUrl, method: .get, parameters: parameters, encoding: URLEncoding.default)
//        .validate()
//        .responseDecodable(of: FoodProductResponse.self) { response in
//            switch response.result {
//            case .success(let foodProductResponse):
//                if let foodProduct = foodProductResponse.data?.result {
//                    completion(.success(foodProduct))
//                } else {
//                    // Handle invalid barcode or no data found
//                    completion(.failure("The barcode is invalid or the product is not found."))
//                }
//            case .failure(let error):
//                if let afError = error.asAFError {
//                    switch afError {
//                    case .sessionTaskFailed(let underlyingError as URLError):
//                        if underlyingError.code == .notConnectedToInternet {
//                            // Handle network error
//                            completion(.failure("No internet connection. Please check your network and try again."))
//                        } else {
//                            // Other URLError
//                            completion(.failure("Network error occurred. Please try again later."))
//                        }
//                    case .responseValidationFailed(let reason):
//                        switch reason {
//                        case .unacceptableStatusCode(let code) where code >= 500:
//                            // Handle server errors
//                            completion(.failure("Server error occurred. Please try again later."))
//                        default:
//                            completion(.failure("Unexpected response error."))
//                        }
//                    default:
//                        completion(.failure("An unknown error occurred. Please try again."))
//                    }
//                } else {
//                    // Handle unexpected errors
//                    completion(.failure("Unexpected error: \(error.localizedDescription)"))
//                }
//            }
//        }
//}
//
//// Example Usage with Error Handling
//fetchFoodProductWithErrorHandling(barcode: "50254156") { result in
//    switch result {
//    case .success(let foodProduct):
//        print("Product fetched successfully: \(foodProduct.tradeName)")
//    case .failure(let errorMessage):
//        print("Error: \(errorMessage)")
//    }
//}
//
//
//// Example Usage
//fetchFoodProduct(barcode: "50254156") { result in
//    switch result {
//    case .success(let foodProduct):
//        print("Food Product Name: \(foodProduct.tradeName)")
//        print("Brand: \(foodProduct.brandName)")
//        print("Weight: \(foodProduct.itemWeight) \(foodProduct.unitNameEn)")
//        print("Country of Production: \(foodProduct.enCOProduction)")
//        print("Storage Temperature: \(foodProduct.storageTemperatureEn)")
//        print("Ingredients: \(foodProduct.ingredientsEn ?? "N/A")")
//    case .failure(let error):
//        print("Error fetching food product: \(error.localizedDescription)")
//    }
//}
