//
//  URLShortenManager.swift
//  URLShortener
//
//  Created by Federico on 11/02/2022.
//
// API: https://tinyurl.com/app/dev
// API Key can be used up to 600 times per day, so make sure to get your own.

import Foundation

// Model
struct URLShort : Codable {
    var data: URLData
    var code: Int
    var errors: [String?]
}

struct URLData : Codable {
    var url: String
    var domain, alias: String
    var tinyURL: String?
}

// Handle requests here
@MainActor class URLShortenManager : ObservableObject {
    private let API_KEY = "2W2AHuEG1XPH17F7qIInwsVTfV4TQ9Ou5DQiq3e7xi6ANkqQpbI6OXB1QoJe"
    
    @Published var resultURL = ""
    @Published var inputURL = "https://www.youtube.com/watch?v=dIOEDC_maAY&ab_channel=CaravanPalace"

    func getData() {
        // Step 1: Provide a URL
        guard let url = URL(string: "https://api.tinyurl.com/create?url=\(inputURL)&api_token=\(API_KEY)") else {
            print("Invalid URL")
            return }
        
        // Step 2: Create a URLSession to handle the URL
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Step 3: Retrieve the data from the URL
            guard let data = data else {
                print("Could not retrieve data...")
                
                DispatchQueue.main.async {
                    self.resultURL = "Could not retrieve data..."
                }
                return }
            
            // Step 4: Decode the data from the URL
            do {
                let shortenedURL = try JSONDecoder().decode(URLShort.self, from: data)
                DispatchQueue.main.async {
                    print(shortenedURL)
                    self.resultURL = "https://tinyurl.com/" + shortenedURL.data.alias
                }
            } catch {
                DispatchQueue.main.async {
                    self.resultURL = "Please enter a valid URL"
                }
                print("\(error)")
            }
        }.resume()
    }
}
