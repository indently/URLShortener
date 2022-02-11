//
//  ContentView.swift
//  URLShortener
//
//  Created by Federico on 11/02/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var shortURL = URLShortenManager()
    
    var body: some View {
        Form() {
            Section("Link") {
                TextEditor(text: $shortURL.inputURL)
                    .frame(height: 100, alignment: .center)
                
                HStack {
                    Spacer()
                    Button("Submit") {
                        if shortURL.inputURL.isEmpty {
                            shortURL.resultURL = "Please add a url..."
                        } else {
                            shortURL.resultURL = "Loading..."
                            shortURL.getData()
                        }
                    }
                    Spacer()
                    .tint(.red)
                }
            }
            Section("Results") {
                TextField("Your shortened link will appear here", text: $shortURL.resultURL)
                    .textSelection(.enabled)
                    .foregroundColor(.green)
                HStack {
                    Spacer()
                    Button("Reset") {
                        shortURL.inputURL = ""
                        shortURL.resultURL = ""
                    }
                    .tint(.red)
                    Spacer()
                }
            }
        }
        .environmentObject(shortURL)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
