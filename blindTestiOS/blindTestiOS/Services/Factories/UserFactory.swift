//
//  UserFactory.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 22/01/2021.
//

import Foundation

class UserFactory {
    
    static func userFrom(dictionnary: [String: Any]) -> User? {
        guard let id = dictionnary["_id"] as? String,
              let name = dictionnary["pseudo"] as? String,
              let password = dictionnary["password"] as? String,
              let number = dictionnary["number"] as? String else {
            return nil
        }
        
        let user = User(id: id, nickname: name, password: password, phone: number)
        return user
    }
    
    static func dictionnaryFromSignUp(user: User) -> [String: Any?] {
        return [
            "pseudo": user.nickname,
            "password": user.password,
            "number": user.phone
        ]
    }
    
    static func dictionnaryFromSignIn(user: User) -> [String: Any?] {
        return [
            "pseudo": user.nickname,
            "password": user.password
        ]
    }
    
}
