//
//  ThemeFactory.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 08/02/2021.
//

import Foundation

class ThemeFactory {
    
    static func themeFrom(dictionnary: [String: Any]) -> Theme? {
        
        guard let id = dictionnary["_id"] as? String,
              let name = dictionnary["name"] as? String else {
            return nil
        }
        
        let theme = Theme(id: id, name: name)
        return theme
        
    }
    
}
