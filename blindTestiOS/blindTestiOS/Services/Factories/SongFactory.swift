//
//  SongFactory.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 04/02/2021.
//

import Foundation

class SongFactory {
    
    static func musicFrom(dictionnary: [String: Any]) -> Music? {
        guard let id = dictionnary["_id"] as? String,
              let name = dictionnary["name"] as? String,
              let themeId = dictionnary["themeID"] as? String,
              let detailId = dictionnary["detailID"] as? String,
              let file = dictionnary["file"] as? String else {
            return nil
        }
        
        let music = Music(id: id, name: name, urlMusic: file, idDetail: detailId, idTheme: themeId)
        
        return music
    }
    
}
