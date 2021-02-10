//
//  GameFactory.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 08/02/2021.
//

import Foundation

class GameFactory {
    
    static func gameFrom(dictionnary: [String: Any]) -> Game? {
        guard let id = dictionnary["_id"] as? String,
              let score = dictionnary["score"] as? Int,
              let gameplayId = dictionnary["gameplayID"] as? String,
              let userId = dictionnary["userID"] as? String,
              let date = dictionnary["createdAt"] as? String else {
            return nil
        }
        
        let game = Game(id: id, score: score, idGameplay: gameplayId, idUser: userId, date: date)
        
        return game
        
    }
    
    static func dictionnaryFrom(game: Game) -> [String: Any] {
        return [
            "name": "test",
            "score": game.score,
            "gameplayID": game.idGameplay,
            "userID": game.idUser
        ]
    }
    
}
