//
//  DetailWebServices.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 04/02/2021.
//

import Foundation

class DetailWebServices {
    
    func getAllDetail(completion: @escaping ([Detail]) -> Void) {
        guard let url = URL(string: API.url + "/detail" + API.token) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, res, err) in
            guard let bytes = data,
                  err == nil,
                  let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [String: Any] else {
                DispatchQueue.main.sync {
                    completion([])
                }
                return
            }
            
            guard let response = ApiResponseFactory.responseFrom(dictionnary: json),
                  response.error == false,
                  let array = response.message as? [[String: Any]] else {
                DispatchQueue.main.sync {
                    completion([])
                }
                return
            }
            
            var details: [Detail] = []
            for i in 0..<array.count {
                guard let detail = DetailFactory.detailFrom(dictionnary: array[i]) else {
                    return
                }
                details.append(detail)
            }
            DispatchQueue.main.sync {
                completion(details)
            }
        }
        task.resume()
    }
    
}
