//
//  UserWebServices.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 25/01/2021.
//

import Foundation

class UserWebServices {
    
    
    func signIn(user: User, completion: @escaping (User?) -> Void) {
        guard let signInUrl = URL(string: API.url + "/user/connexion" + API.token) else {
            return
        }
        
        var request = URLRequest(url: signInUrl)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: UserFactory.dictionnaryFromSignIn(user: user), options: .fragmentsAllowed)
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
                  let getUser = UserFactory.userFrom(dictionnary: ((response.message as? [String: Any])!)) else {
                DispatchQueue.main.sync {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.sync {
                completion(getUser)
            }
        }
        task.resume()
    }
    
    func signUp(user: User, completion: @escaping (User?) -> Void) {
        guard let signUpUrl = URL(string: API.url + "/user" + API.token) else {
            return
        }
        
        var request = URLRequest(url: signUpUrl)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: UserFactory.dictionnaryFromSignUp(user: user), options: .fragmentsAllowed)
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
                  let getUser = UserFactory.userFrom(dictionnary: ((response.message as? [String: Any])!)) else {
                DispatchQueue.main.sync {
                    completion(nil)
                }
                print("err2")
                return
            }
            
            DispatchQueue.main.sync {
                print("good")
                completion(getUser)
            }
        }
        task.resume()
    }
    
    func getById(id: String, completion: @escaping (User?) -> Void) {
        guard let getByIdUrl = URL(string: API.url + "/user/" + id + API.token) else {
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
                  let getUser = UserFactory.userFrom(dictionnary: ((response.message as? [String: Any])!)) else {
                DispatchQueue.main.sync {
                    completion(nil)
                }
                return
                
            }
            
            DispatchQueue.main.sync {
                completion(getUser)
            }
            
        }
        task.resume()
    }
    
}
