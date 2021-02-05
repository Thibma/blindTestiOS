//
//  GameplayFactory.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 02/02/2021.
//

import Foundation

class GameplayFactory {
    
    static func gameplayFrom(dictionnary: [String: Any]) -> Gameplay? {
        guard let id = dictionnary["_id"] as? String,
              let name = dictionnary["name"] as? String,
              let description = dictionnary["description"] as? String else {
            return nil
        }
        let maxPoint = dictionnary["maxPoints"] as? Int
        let maxSongs = dictionnary["maxSongs"] as? Int
        let tries = dictionnary["tries"] as? Int
        
        let gameplay = Gameplay(id: id, maxPoints: maxPoint, maxSongs: maxSongs, tries: tries, name: name, descr: description)
        return gameplay
    }
    
}
