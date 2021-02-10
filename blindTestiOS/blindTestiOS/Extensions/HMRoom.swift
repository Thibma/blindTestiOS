//
//  HMRoom.swift
//  blindTestiOS
//
//  Created by macos on 10/02/2021.
//

import Foundation
import HomeKit

extension HMRoom {
    
    func getAccessories() -> [HMAccessory] {
        let accessories = self.accessories.filter({ (accessory: HMAccessory) in
            return accessory.isReachable && accessory.hasHue()
        })
        return accessories
    }
}
