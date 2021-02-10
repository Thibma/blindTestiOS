//
//  BlindtestFacroty.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 08/02/2021.
//

import Foundation

class BlindtestFactory {
    
    static func blindtestFrom(dictionnary: [String: Any]) -> Blindtest? {
        guard let id = dictionnary["_id"] as? String,
              let score = dictionnary["score"] as? Int,
              let songId = dictionnary["songID"] as? String,
              let gameId = dictionnary["gameID"] as? String else {
            return nil
        }
        
        return Blindtest(id: id, score: score, musicId: songId, gameId: gameId)
    }
    
    static func dictionnaryFrom(blindtest: Blindtest) -> [String: Any] {
        
        return [
            "score": blindtest.score,
            "gameID": blindtest.gameId,
            "songID": blindtest.musicId
        ]
        
    }
    
}
