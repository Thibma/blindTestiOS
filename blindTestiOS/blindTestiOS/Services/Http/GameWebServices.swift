//
//  GameWebServices.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 08/02/2021.
//

import Foundation

class GameWebService {
    
    func saveGame(game: Game, completion: @escaping (Game?) -> Void) {
        guard let signInUrl = URL(string: API.url + "/game" + API.token) else {
            return
        }
        
        var request = URLRequest(url: signInUrl)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: GameFactory.dictionnaryFrom(game: game), options: .fragmentsAllowed)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, res, err) in
            guard let bytes = data,
                  err == nil,
                  let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [String: Any] else {
                DispatchQueue.main.sync {
                    completion(nil)
                }
                return
            }
            guard let response = ApiResponseFactory.responseFrom(dictionnary: json),
                  response.error == false,
                  let getGame = GameFactory.gameFrom(dictionnary: ((response.message as? [String: Any])!)) else {
                DispatchQueue.main.sync {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.sync {
                completion(getGame)
            }
        }
        task.resume()
    }
    
    func getAllGamesByUser(userId: String, completion: @escaping ([Game]) -> Void) {
        guard let url = URL(string: API.url + "/game/byUser/" + userId + API.token) else {
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
            
            var games: [Game] = []
            for i in 0..<array.count {
                guard let game = GameFactory.gameFrom(dictionnary: array[i]) else {
                    return
                }
                games.append(game)
            }
            DispatchQueue.main.sync {
                completion(games)
            }
        }
        task.resume()
    }
    
    func getAllBestGames(completion: @escaping ([Game]) -> Void) {
        guard let url = URL(string: API.url + "/game/best" + API.token) else {
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
            
            var games: [Game] = []
            for i in 0..<array.count {
                guard let game = GameFactory.gameFrom(dictionnary: array[i]) else {
                    return
                }
                games.append(game)
            }
            DispatchQueue.main.sync {
                completion(games)
            }
        }
        task.resume()
    }
    
}
