//
//  ContentView.swift
//  WordScramble
//
//  Created by Adam Wilson on 5/18/24.
//

import SwiftUI

struct ContentView: View {
    
    // set up variables
    // ______________________________
    
    @State private var usedWords = [String]()
    
    @State private var rootWord = ""
    
    @State private var newWord = ""
    
    // for error tracking
    // _______________________________
    
    @State private var errorTitle = ""
    
    @State private var errorMessage = ""
        
    @State private var showingError = false
    
    // score variable (variables?)
    // _________________________________
    
    @State private var score = 0
    
   
    
    
    
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
                
                Section {
                    
                    // show score
                    
                    Text("Score: \(score)")
                    
                    
                }
                
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) { } message: {
                 
                Text(errorMessage)
            }
            .toolbar {
                
                Button(action: startGame ) {
                    
                   Image(systemName: "arcade.stick.console")
                    
                }
                
            }
        }
        
    }
    
    func updateScore() {
        
        score = score + 10
        
    }
    
    
    func addNewWord() {
        
        // set the word lowercase, trim the word (get rid of white space) we put in and submit it as an answer
        
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // make sure there's at least one character in the text box
        
        guard answer.count > 0 else { return }
        
        
        // make sure word has at least 2 characters
        
        guard answer.count >= 2 else {
            
            wordError(title: "Word too short", message: "You can only use words that have more than 2 letters.")
            
                
            newWord = ""
            
            return
            
        }
        
        
        // User can't use root word as an answer
        
        guard answer != rootWord else {
            
            wordError(title: "Ummm..... look at the root word...", message: "Is the root word the same?  Yeeeaaaahhh.... can't use it!!")
            
            newWord = ""
            
            return
        }
        
        guard isOriginal(word: answer) else {
            
            wordError(title: "Word used already", message: "Please be more original!")
            
            newWord = ""
            
            return
        }
        
        guard isPossible(word: answer) else {
            
            wordError(title: "This is not a possible word", message: "You can't spell that word from '\(rootWord)'!")
            
            newWord = ""
            
            return
        }
        
        guard isReal(word: answer) else {
            
            wordError(title: "Word not recognized", message: "You can't just make them up, y'know!")
            
          
            newWord = ""
            
            return
        }
        
       
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        newWord = ""
        
        // update score only if word is valid
        
        updateScore()
    }
    
    func startGame() {
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            
            if let startWords = try? String(contentsOf: startWordsURL) {
                
                let allWords = startWords.components(separatedBy: "\n")
                
                rootWord = allWords.randomElement() ?? "orjentha"
                
                newWord = ""
                
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
