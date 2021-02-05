//
//  Theme.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 02/02/2021.
//

import Foundation

class Theme: CustomStringConvertible {
    
    let id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    var description: String {
        return "\(self.id) \(self.name)"
    }
    
}
