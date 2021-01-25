//
//  ApiResponse.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 25/01/2021.
//

import Foundation

class ApiResponse {
    let error: Bool
    let message: Any
    
    init(error: Bool, message: Any) {
        self.error = error
        self.message = message
    }
}
