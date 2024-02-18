//
//  ContentView.swift
//  llama2watch Watch App
//
//  Created by Tyler Kruer on 2/17/24.
//

import SwiftUI

// Define a global variable to hold the callback closure
var outputCallbackClosure: ((String) -> Void)?

// Define a function that matches the C callback signature
func outputCallback(text: UnsafePointer<CChar>?) {
    if let text = text, let closure = outputCallbackClosure {
        let string = String(cString: text)
        DispatchQueue.main.async {
            closure(string)
        }
    }
}

// Declare the setOutputCallback function from C code
//func setOutputCallback(_ callback: @escaping @convention(c) (UnsafePointer<CChar>?) -> Void) {}
func safeText(_ piece: String) -> String? {
    guard !piece.isEmpty else { return nil }
    if piece.count == 1 {
        let byteValue = piece.utf8[piece.utf8.startIndex]
        if !(32...126 ~= byteValue || byteValue == 9 || byteValue == 10 || byteValue == 13) {
            return nil // Filter out non-printable characters and non-whitespace
        }
    }
    return piece // Return printable characters and whitespace
}



struct ContentView: View {
    @State private var outputText: String = ""
    @State private var userInput: String = ""
    @State private var scrollTarget: Int? = nil
    @State private var lineCount: Int = 0
    @State private var isLoading: Bool = false

    var body: some View {
        ScrollView {
            TextField("Enter a prompt", text: $userInput).padding()
            
            Button("Generate") {
                isLoading = true // Start loading
                outputText = "" // Clear previous output
                if let bundlePath = Bundle.main.path(forResource: "stories42M", ofType: "bin"),
                   let tokenizerPath = Bundle.main.path(forResource: "tokenizer", ofType: "bin") {
                    
                    
                    outputCallbackClosure = { text in
                                            if let safeText = safeText(String(cString: text)) {
                                                DispatchQueue.main.async {
                                                    self.outputText += safeText
                                                    isLoading = false // Stop loading when text is received
                                                }
                                            }
                                        }
                    
                    setOutputCallback(outputCallback)

                    var args = ["run", bundlePath, tokenizerPath, "-i", "Once upon a time", "-n", "256"]
                    
                    args.withCStrings { argv in
                        let argc = Int32(args.count)
                        var mutableArgv = argv
                        mutableArgv.withUnsafeMutableBufferPointer { argvBuffer in
                            let _ = mainLlama(argc, argvBuffer.baseAddress)
                        }
                    }
                }
            }
            Divider()
            if isLoading {
                ProgressView()
                    
            } else {
                ScrollView {
                    Text(outputText)
                        .padding()
                        .frame(maxHeight: 300)
                }
            }
        }
    }
}



extension Array where Element == String {
    func withCStrings<R>(_ body: ([UnsafeMutablePointer<CChar>?]) -> R) -> R {
        var cStrings = self.map { strdup($0) } + [nil]
        defer { cStrings.forEach { free($0) } }
        return body(cStrings)
    }
}



#Preview {
    ContentView()
}
