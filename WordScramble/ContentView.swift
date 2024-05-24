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
                        .textInputAutocapitalization(.never)
                    
                }
                
              Section {
                    
                    ForEach(usedWords, id: \.self) { word in
                        
                        HStack {
                            
                            Image(systemName: "\(word.count).circle")
                            
                            Text(word)
                            
                        }
                        
                    }
                    
                }
                
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
        }
        
    }
    
    func addNewWord() {
        
        // set the word lowercase, trim the word (get rid of white space) we put in and submit it as an answer
        
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // make sure there's at least one character in the text box
        
        guard answer.count > 0 else { return }
        
        // extra validation to come
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        newWord = ""
    }
}

#Preview {
    ContentView()
}
