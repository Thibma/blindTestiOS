//
//  Detail.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 04/02/2021.
//

import Foundation

class Detail: CustomStringConvertible {
    let name: String
    let id: String
    let imageUrl: String
    
    var responses: [String] = []

    init(id: String, name: String, imageUrl: String) {
        self.name = name
        self.id = id
        self.imageUrl = imageUrl
    }
    
    var description: String {
        return "\(self.name) \(self.id) \(self.imageUrl)"
    }
    
    func setResponses(details: [Detail]) {
        var copyDetail = details
        let randomGoodPosition = Int.random(in: 0..<4)
        
        for i in 0..<4 {
            
            if randomGoodPosition == i {
                responses.append(self.name)
            }
            
            else {
                var randomDetail = Int.random(in: 0..<copyDetail.count)
                while copyDetail[randomDetail].name == self.name {
                    randomDetail = Int.random(in: 0..<copyDetail.count)
                }
                responses.append(copyDetail[randomDetail].name)
                copyDetail.remove(at: randomDetail)
            }
            
        }
    }
}
