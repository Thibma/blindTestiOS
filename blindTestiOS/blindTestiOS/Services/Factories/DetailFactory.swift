//
//  DetailFactory.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 04/02/2021.
//

import Foundation

class DetailFactory {
    
    static func detailFrom(dictionnary: [String: Any]) -> Detail? {
        guard let id = dictionnary["_id"] as? String,
              let name = dictionnary["name"] as? String,
              let image = dictionnary["image"] as? String else {
            return nil
        }
        
        let detail = Detail(id: id, name: name, imageUrl: image)
        return detail
    }
    
}
