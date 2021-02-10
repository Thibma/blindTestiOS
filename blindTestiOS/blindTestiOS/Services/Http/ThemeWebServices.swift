//
//  ThemeWebServices.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 02/02/2021.
//

import Foundation

class ThemeWebServices {
    
    func getAllThemes(completion: @escaping ([Theme]) -> Void) {
        
        guard let url = URL(string: API.url + "/theme" + API.token) else {
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
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            var themes: [Theme] = []
            for i in 0..<array.count {
                guard let theme = ThemeFactory.themeFrom(dictionnary: array[i]) else {
                    return
                }
                themes.append(theme)
            }
            
            DispatchQueue.main.sync {
                completion(themes)
            }
        }
        task.resume()
        
    }
    
    func getById(id: String, completion: @escaping (Theme?) -> Void) {
        guard let getByIdUrl = URL(string: API.url + "/theme/" + id + API.token) else {
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
                  let getTheme = ThemeFactory.themeFrom(dictionnary: ((response.message as? [String: Any])!)) else {
                DispatchQueue.main.sync {
                    completion(nil)
                }
                return
                
            }
            
            DispatchQueue.main.sync {
                completion(getTheme)
            }
            
        }
        task.resume()
    }
    
}
