//
//  NetworkManager.swift
//  FlickerApp
//
//  Created by Anusha Raju on 12/12/24.
//

import UIKit
import Foundation

protocol Network{
    func fetchData<T: Decodable>(from url: String) async throws -> T
}

class NetworkManager: Network {
    static let sharedInstance = NetworkManager()
    private init() { }
    
    //MARK: - Get data from the URL
    func fetchData<T: Decodable>(from url: String) async throws -> T {
        guard let serverUrl =  URL(string: url) else {
            print("getData: Invalid URL")
            throw DataError.invalidURL
        }
        
        let(data, response) = try await URLSession.shared.data(from: serverUrl)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("getData: Invalid response")
            throw DataError.invalidData
        }
        
        let dataResponse = try JSONDecoder().decode(T.self, from: data)
//        print(dataResponse)
        return dataResponse
    }
}

