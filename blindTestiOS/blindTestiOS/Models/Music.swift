//
//  Music.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 04/02/2021.
//

import Foundation

class Music: CustomStringConvertible {
    let id: String
    let name: String
    let urlMusic: String
    let idDetail: String
    let idTheme: String
    
    var responses: [String] = []
    
    init(id: String, name: String, urlMusic: String, idDetail: String, idTheme: String) {
        self.id = id
        self.name = name
        self.urlMusic = urlMusic
        self.idDetail = idDetail
        self.idTheme = idTheme
    }
    
    var description: String {
        return "\(self.id) \(self.name) \(self.urlMusic) \(self.idDetail) \(self.idTheme)"
    }
    
    func setResponses(musics: [Music]) {
        var copyMusic = musics
        let randomGoodPosition = Int.random(in: 0..<4)
        
        for i in 0..<4 {
            
            if randomGoodPosition == i {
                responses.append(self.name)
            }
            
            else {
                var randomMusic = Int.random(in: 0..<copyMusic.count)
                while copyMusic[randomMusic].name == self.name {
                    randomMusic = Int.random(in: 0..<copyMusic.count)
                }
                responses.append(copyMusic[randomMusic].name)
                copyMusic.remove(at: randomMusic)
            }
            
        }
    }
}
