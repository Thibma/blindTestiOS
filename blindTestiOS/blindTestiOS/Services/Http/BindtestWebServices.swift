//
//  BindtestWebServices.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 08/02/2021.
//

import Foundation

class BlindtestWebService {
    
    func saveBlindtest(blindtest: Blindtest, completion: @escaping(Bool) -> Void) {
        
        guard let url = URL(string: API.url + "/blindtest" + API.token) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: BlindtestFactory.dictionnaryFrom(blindtest: blindtest), options: .fragmentsAllowed)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, res, err) in
            guard let bytes = data,
                  err == nil,
                  let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [String: Any] else {
                DispatchQueue.main.sync {
                    completion(false)
                }
                return
            }
            
            guard let response = ApiResponseFactory.responseFrom(dictionnary: json),
                  response.error == false else {
                DispatchQueue.main.sync {
                    completion(false)
                }
                return
            }
            
            DispatchQueue.main.sync {
                completion(true)
            }
        }
        task.resume()
        
    }
    
    func getBlindtestByGame(game: Game, completion: @escaping ([Blindtest]) -> Void) {
        guard let url = URL(string: API.url + "/blindtest/byGame/" + game.id! + API.token) else {
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
            
            var blindtests: [Blindtest] = []
            for i in 0..<array.count {
                guard let blindtest = BlindtestFactory.blindtestFrom(dictionnary: array[i]) else {
                    return
                }
                blindtests.append(blindtest)
            }
            DispatchQueue.main.sync {
                completion(blindtests)
            }
        }
        task.resume()
    }
    
}
