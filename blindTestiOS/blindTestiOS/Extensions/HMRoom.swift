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
            return accessory.isReachable && nil != accessory.services.first(where: { (service: HMService) in
                return nil != service.characteristics.first(where: { (characteristic: HMCharacteristic) in
                    return characteristic.characteristicType == HMCharacteristicTypeHue
                })
            })
        })
        return accessories
    }
}
