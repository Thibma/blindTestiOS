//
//  User.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 22/01/2021.
//

import Foundation

class User {
    
    let id: String?
    let nickname: String
    let password: String?
    let phone: String?
    
    // All from API
    init(id: String, nickname: String, password: String, phone: String) {
        self.id = id
        self.nickname = nickname
        self.password = password
        self.phone = phone
    }
    
    // Get the User with nickname and id
    init(id: String, nickname: String) {
        self.id = id
        self.nickname = nickname
        self.password = nil
        self.phone = nil
    }
    
    // Send to the API when inscription
    init(nickname: String, password: String, phone: String) {
        self.id = nil
        self.nickname = nickname
        self.password = password
        self.phone = phone
    }
    
    // Send to the API for the connexion
    init(nickname: String, password: String) {
        self.id = nil
        self.nickname = nickname
        self.password = password
        self.phone = nil
    }
}
