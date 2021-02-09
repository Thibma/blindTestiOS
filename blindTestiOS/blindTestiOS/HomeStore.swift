//
//  HomeStore.swift
//  blindTestiOS
//
//  Created by macos on 08/02/2021.
//

import Foundation
import HomeKit

class HomeStore: NSObject {
    /// A singleton that can be used anywhere in the app to access the home manager.
    static var shared = HomeStore()
    
    /// The one and only home manager that belongs to the home store singleton.
    let homeManager = HMHomeManager()
    
    /// A set of objects that want to receive home delegate callbacks.
    var homeDelegates = Set<NSObject>()
    
    /// A set of objects that want to receive accessory delegate callbacks.
    var accessoryDelegates = Set<NSObject>()
}

