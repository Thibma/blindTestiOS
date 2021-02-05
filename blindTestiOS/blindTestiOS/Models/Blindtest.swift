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
    
    init(id: String?, score: Int, musicId: String) {
        self.id = id
        self.score = score
        self.musicId = musicId
    }
    
    init(score: Int, musicId: String) {
        self.id = nil
        self.score = score
        self.musicId = musicId
    }
}
