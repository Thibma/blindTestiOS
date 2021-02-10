//
//  Blindtest.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 04/02/2021.
//

import Foundation

class Blindtest {
    let id: String?
    let score: Int
    let musicId: String
    var gameId: String?
    
    init(id: String?, score: Int, musicId: String, gameId: String) {
        self.id = id
        self.score = score
        self.musicId = musicId
        self.gameId = gameId
    }
    
    init(score: Int, musicId: String) {
        self.id = nil
        self.score = score
        self.musicId = musicId
        self.gameId = nil
    }
}
