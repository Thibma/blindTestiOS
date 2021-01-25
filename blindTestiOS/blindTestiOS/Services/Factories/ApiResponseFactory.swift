//
//  Response.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 25/01/2021.
//

import Foundation

class ApiResponseFactory {

    static func responseFrom(dictionnary: [String: Any]) -> ApiResponse? {
        guard let e = dictionnary["error"] as? Bool,
              let m = dictionnary["message"] else {
            return nil
        }
        
        return ApiResponse(error: e, message: m)
    }
}
