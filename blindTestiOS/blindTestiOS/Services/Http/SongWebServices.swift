//
//  SongWebServices.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 04/02/2021.
//

import Foundation

class SongWebServices {
    
    func getAllSongs(completion: @escaping ([Music]) -> Void) {
        guard let url = URL(string: API.url + "/song" + API.token) else {
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
            
            var musics: [Music] = []
            for i in 0..<array.count {
                guard let music = SongFactory.musicFrom(dictionnary: array[i]) else {
                    return
                }
                musics.append(music)
            }
            DispatchQueue.main.sync {
                completion(musics)
            }
        }
        task.resume()
    }
    
    func getByBlindtestId(id: String, completion: @escaping (Music?) -> Void) {
        guard let getByIdUrl = URL(string: API.url + "/song/" + id + API.token) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: getByIdUrl) { (data: Data?, res, err) in
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
                  let getMusic = SongFactory.musicFrom(dictionnary: ((response.message as? [String: Any])!)) else {
                DispatchQueue.main.sync {
                    completion(nil)
                }
                return
                
            }
            
            DispatchQueue.main.sync {
                completion(getMusic)
            }
            
        }
        task.resume()
    }
}
