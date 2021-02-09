//
//  HMCharacteristic.swift
//  blindTestiOS
//
//  Created by macos on 09/02/2021.
//

import Foundation
import HomeKit

extension HMCharacteristic{

    func containsProperty(param: String) -> Bool {
        return self.properties.contains(param)
    }

    func isReadable() -> Bool {
        return containsProperty(param: HMCharacteristicPropertyReadable)
    }

    func isWritable() -> Bool {
        return containsProperty(param: HMCharacteristicPropertyWritable)
    }
}
