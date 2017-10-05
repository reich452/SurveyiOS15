//
//  Survey.swift
//  SurveyiOS15
//
//  Created by Nick Reichard on 10/5/17.
//  Copyright © 2017 Nick Reichard. All rights reserved.
//

import Foundation

struct Survey {
    
    // MARK: - Keys
    private let nameKey = "name"
    private let emojiKey = "emoji"
    private let uuidKey = "uuid"
    
    // MARK: - Properties
    let name: String
    let emoji: String
    let identifier: UUID // - Like a timestamp. Right then and there
    
    // MARK: - MemberWize
    init(name: String, emoji: String, identifier: UUID = UUID()) {
        self.name = name
        self.emoji = emoji
        self.identifier = identifier
    }

    // MARK: - Failable --
    init?(dictionary: [String: String], identifier: String) {
       guard let name = dictionary[nameKey] as? String,
        let emoji = dictionary[emojiKey] as? String,
        let identifier = UUID(uuidString: identifier) else { return nil }
        
        self.name = name
        self.emoji = emoji
        self.identifier = identifier
    }
    
    // MARK: - Dictionary Rep
    var dictionaryRep: [String: Any] {
        let dictionary: [String: Any] = [
            nameKey: name,
            emojiKey: emoji,
            uuidKey: identifier.uuidString
        ]
        return dictionary
    }
    // Trun or serialize dictionaryRep into Data
    // Return JSON data from our object
    // MARK: - PUT to JSON
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: dictionaryRep, options: .prettyPrinted)
    }
    
}













