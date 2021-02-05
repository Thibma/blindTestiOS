//
//  Gameplay.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 02/02/2021.
//

import Foundation

class Gameplay: CustomStringConvertible {
    
    let id: String
    
    // Si null -> Fin de la partie atteinte par max song ou tries
    let maxPoints: Int?
    
    // Si null -> Fin de la partie atteinte par max point ou tries
    let maxSongs: Int?
    
    // Vies
    let tries: Int?
    
    
    let name: String
    let descr: String
    
    init(id: String,
         maxPoints: Int?,
         maxSongs: Int?,
         tries: Int?,
         name: String,
         descr: String) {
        self.id = id
        self.maxPoints = maxPoints
        self.maxSongs = maxSongs
        self.tries = tries
        self.name = name
        self.descr = descr
    }
    
    var description: String {
        return "\(self.id) \(self.maxSongs) \(self.maxPoints) \(self.tries) \(self.name) \(self.descr)"
    }
    
}
