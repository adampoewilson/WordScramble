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
    
    // for error tracking
    
    @State private var errorTitle = ""
    
    @State private var errorMessage = ""
    
    @State private var showingError = false
    
    
    
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
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) { } message: {
                 
                Text(errorMessage)
            }
        }
        
    }
    
    func addNewWord() {
        
        // set the word lowercase, trim the word (get rid of white space) we put in and submit it as an answer
        
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // make sure there's at least one character in the text box
        
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            
            wordError(title: "Word used already", message: "Please be more original!")
            
            return
        }
        
        guard isPossible(word: answer) else {
            
            wordError(title: "This is not a possible word", message: "You can't spell that word from '\(rootWord)'!")
            
            return
        }
        
        guard isReal(word: answer) else {
            
            wordError(title: "Word not recognized", message: "You can't just make them up, y'know!")
            
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        newWord = ""
    }
    
    func startGame() {
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            
            if let startWords = try? String(contentsOf: startWordsURL) {
                
                let allWords = startWords.components(separatedBy: "\n")
                
                rootWord = allWords.randomElement() ?? "orjentha"
                
                return
            }
            
        }
       
        fatalError("I'm sorry, the game could not find and load start.txt; the game will now exit.")
        
    }
    
    func isOriginal(word: String) -> Bool {
        
        // is the word we've used original
        
        !usedWords.contains(word)
    }
    
    func isPossible (word: String) -> Bool {
        
        //is the word we've used possible
        
        var tempWord = rootWord
        
        for letter in word {
            
            if let position = tempWord.firstIndex(of: letter) {
                
                tempWord.remove(at: position)
                
            } else {
                
                return false
            }
                
        }
       return true
    }
    
    func isReal(word: String) -> Bool {
        
        let checker = UITextChecker()
        
        let range = NSRange(location: 0, length: word.utf16.count)
        
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    
    func wordError(title: String, message: String) {
        
        errorTitle = title
        
        errorMessage = message
        
        showingError = true
        
    }
}

#Preview {
    ContentView()
}
