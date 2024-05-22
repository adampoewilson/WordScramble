//
//  ContentView.swift
//  WordScramble
//
//  Created by Adam Wilson on 5/18/24.
//

import SwiftUI

struct ContentView: View {
    
    // set up variables
    
    @State private var usedWords = [String]()
    
    @State private var rootWord = ""
    
    @State private var newWord = ""
    
    var body: some View {
        
        
        NavigationStack {
            
            List {
                
                Section {
                    
                    TextField("Enter your word:", text: $newWord)
                    
                }
                
            }
            
        }
    }
}

#Preview {
    ContentView()
}
