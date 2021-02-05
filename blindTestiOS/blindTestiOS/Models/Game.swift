//
//  Game.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 04/02/2021.
//

import Foundation

class Game {
    let id: String?
    let score: Int
    let idGameplay: String
    let blindtests: [Blindtest]!
    let fightId: String?
    let idUser: String
    
    init(score: Int, idGameplay: String, idUser: String) {
        self.score = score
        self.idGameplay = idGameplay
        self.idUser = idUser
        
        self.id = nil
        self.fightId = nil
        self.blindtests = []
    }
}
