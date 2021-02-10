//
//  HMAccessory.swift
//  blindTestiOS
//
//  Created by macos on 10/02/2021.
//

import Foundation
import HomeKit

extension HMAccessory {
    
    func hasHue() -> Bool {
        for service in self.services {
            for characteristic in service.characteristics {
                if characteristic.characteristicType == HMCharacteristicTypeHue {
                    return true
                }
            }
        }
        return false
    }
}
