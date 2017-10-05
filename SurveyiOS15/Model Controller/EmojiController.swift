//
//  EmojiController.swift
//  SurveyiOS15
//
//  Created by Nick Reichard on 10/5/17.
//  Copyright © 2017 Nick Reichard. All rights reserved.
//

import Foundation

class SurveyController {
    static let shared = SurveyController()
    
    // MARK: - SOURCH OF TRUTH
    var surveys: [Survey] = []
    
    /*
     The empty completion is a great way to notify the caller of the fuction that you are done running your code. You can complete with an ojbect or an array of objects when the coller needs to access them. Both options give you the benefit of knowing exactly when that fuction is done running. This is always nice when you are running async code. Buecause you dont know HOW LONG IT WILL TAKE!
     */
    
    private let baseURL = URL(string: "https://favemojiios15.firebaseio.com/")
    
    func putSurvery(with name: String, emoji: String, completion: @escaping(_ success: Bool) -> Void) {
        
        // Create an instance of SURVEY
        let survey = Survey(name: name, emoji: emoji)
        
        guard let url = baseURL else { fatalError("BAD URL")}
        
        // Build the url
        let requestURL = url.appendingPathExtension("json")
        
        // Create the request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        request.httpBody = survey.jsonData
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            var success = false
            
            defer { completion(success)}
            
            // SOme Super duper error handeling
            if let error = error {
                print("Brian broke our request \(error.localizedDescription) \(#function)")
                
            }
            guard let data = data,   // JUST FOR THE DEVELOPER
                let responseDataString = String(data: data, encoding: .utf8) else { return }
            if let error = error {
                print("Error: \(error.localizedDescription) \(#function)")
            } else {
                print("Successfully saved data to endpoint \(responseDataString)")
            }
            // add survey to our sourcer of truth
            self.surveys.append(survey)
            
            success = true
            
            }.resume()
    }
    
    func fetchEmoji(completion: @escaping ([Survey]?) -> Void) {
        
        guard let url = baseURL?.appendingPathExtension("json") else {
            print("Bad baseURL")
            completion([])
            return
        }
        
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                print(" Error fetching \(error.localizedDescription) \(#function) \(#file)")
                completion([])
                return
            }
            guard let data = data else {
                print("No data returned from data task")
                completion([])
                return
            }
            
            // Serialize our data
            guard let surveyDictionaries = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: String]]) else {
                print(" Fetching from JSONObject")
                completion([])
                return
                
            }
            
            guard let surveys = surveyDictionaries?.flatMap({Survey(dictionary: $0.value, identifier: $0.key)}) else { return }
            
            self.surveys = surveys
            completion(surveys)
        }.resume()
        
    }
}





