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
    let date: String!
    
    var theme: Theme! = nil
    var gameplay: Gameplay! = nil
    var user: User! = nil
    
    init(score: Int, idGameplay: String, idUser: String) {
        self.score = score
        self.idGameplay = idGameplay
        self.idUser = idUser
        
        self.id = nil
        self.fightId = nil
        self.blindtests = []
        self.date = nil
    }
    
    init(id: String, score: Int, idGameplay: String, idUser: String, date: String) {
        self.score = score
        self.idGameplay = idGameplay
        self.idUser = idUser
        
        self.id = id
        self.fightId = nil
        self.blindtests = []
        self.date = date
    }
    
    func getDateFromString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: self.date)
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "fr")
        return formatter.string(from: date!)
    }
    
    func getGameplayFromId(gameplays: [Gameplay]) -> Gameplay? {
        for gameplay in gameplays {
            if self.idGameplay == gameplay.id {
                return gameplay
            }
        }
        return nil
    }
    
}
