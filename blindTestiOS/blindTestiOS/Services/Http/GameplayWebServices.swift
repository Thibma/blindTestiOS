//
//  GameplayWebServices.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 02/02/2021.
//

import Foundation

class GameplayWebServices {
    
    func getAllGameplay(completion: @escaping ([Gameplay]) -> Void) {
        guard let url = URL(string: API.url + "/gameplay" + API.token) else {
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
            var gameplays: [Gameplay] = []
            for i in 0..<array.count {
                guard let gameplay = GameplayFactory.gameplayFrom(dictionnary: array[i]) else {
                    print("noo")
                    return
                }
                gameplays.append(gameplay)
            }
            
            DispatchQueue.main.sync {
                completion(gameplays)
            }
        }
        task.resume()
    }
    
}
