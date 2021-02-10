//
//  HMHome.swift
//  blindTestiOS
//
//  Created by macos on 10/02/2021.
//

import Foundation
import HomeKit

extension HMHome {
    
    func getRoom() -> HMRoom? {
        let roomName: String = HomeStore.shared.roomName
        return self.rooms.first(where: { $0.name == roomName })
    }
}
